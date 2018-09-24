require "graphql/client"
require "graphql/client/http"

module Github
  GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN'] #your personal access token here
  puts GITHUB_ACCESS_TOKEN.inspect
  URL = 'https://api.github.com/graphql'
  HTTP = GraphQL::Client::HTTP.new(URL) do
    def headers(context)
      {
        "Authorization" => "Bearer #{GITHUB_ACCESS_TOKEN}",
        "User-Agent" => 'Ruby'
      }
    end
  end
  #aside: graphql client usage guide recommends loading the schema from disk
  #for now, make a request each time
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  class Repo
    #query for searching all repos
    RepoSearchQuery = Github::Client.parse <<-'GRAPHQL'
      query($query: String!) {
        search(first: 10, query: $query, type: REPOSITORY) { #only get 10 results as required
          nodes{
            ... on Repository{
              nameWithOwner
              url
              id
              primaryLanguage{
                name
              }
              releases(first: 1, orderBy: {field: CREATED_AT, direction: DESC}){ #sort releases by newest
                nodes{
                  tag{
                    name
                  }
                }
              }
              viewerHasStarred
            }
          }
        }
      }
    GRAPHQL

    #query for finding favourited repos + pagination
    RepoStarredQuery = Github::Client.parse <<-'GRAPHQL'
      query($after: String){
        viewer {
          starredRepositories(first: 10, after: $after) {
            nodes {
              id
              nameWithOwner
              url
              primaryLanguage{
                name
              }
              releases(first: 1, orderBy: {field: CREATED_AT, direction: DESC}){
                nodes{
                  tag{
                    name
                  }
                }
              }
            }
            pageInfo{
                endCursor
                hasNextPage
            }
          }
        }
      }
    GRAPHQL

    #query for adding a repo to favourites
    AddStarMut = Github::Client.parse <<-'GRAPHQL'
      mutation($id: ID!){
        addStar(input:{starrableId: $id}){
          starrable{
            viewerHasStarred #to check if the star was added successfully
          }
        }
      }
    GRAPHQL

    #query for removing a repo from favourites
    RemoveStarMut = Github::Client.parse <<-'GRAPHQL'
      mutation($id: ID!){
        removeStar(input:{starrableId: $id}){
          starrable{
            viewerHasStarred
          }
        }
      }
    GRAPHQL

    #get a list of 10 repos matching the search query
    def self.find(query)
      response = Github::Client.query(RepoSearchQuery, variables: { query: query })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors[:data].join(", "))
      else
        response.data.search
      end
    end

    #find all of my favourited repos
    def self.findStarred()
      favrepos = [] #variable to add successive page data to
      cursor = nil #cursor variable for determining where to start query
      loop do
        response = Github::Client.query(RepoStarredQuery, variables: { after: cursor })
        if response.errors.any?
          raise QueryExecutionError.new(response.errors[:data].join(", "))
        else
          next_page =  response.data.viewer.starred_repositories.page_info.has_next_page
          favrepos.concat(response.data.viewer.starred_repositories.nodes)
        end
        break if !next_page
        cursor = response.data.viewer.starred_repositories.page_info.end_cursor
      end
      favrepos
    end

    #Add repo with given id to favourites
    def self.addStar(id)
      response = Github::Client.query(AddStarMut, variables: { id: id })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors)
      end
    end

    #remove repo with given id from favourites
    def self.removeStar(id)
      response = Github::Client.query(RemoveStarMut, variables: { id: id })
      if response.errors.any?
        raise QueryExecutionError.new(response.errors)
      end
    end

  end
end