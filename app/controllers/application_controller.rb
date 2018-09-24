class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
  	#home is making queries for now due to redirect reasons
  	@starred_repos = Github::Repo.findStarred
  	if params[:query]
	  	query = params[:query]
	    repos = Github::Repo.find(query)
	    @results = repos.nodes
	  end
  	render template: "home"
  end
end
