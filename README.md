# Shopify - Web Developer Internship Challenge - W2019

### Description

Solution fulfils all listed requirements of the [Shopify - Winter 2019 - Web Developer Internship Challenge](https://drive.google.com/file/d/1m99bOQvewIpx0POBtGwFayZqcpiM5cXP/view). Thus, it should be possible to search Github repositories, favourite repos, and manage favourites.

A deployed instance is available to view and test [here](https://peaceful-shore-72518.herokuapp.com/).

##### Bonus Features

  * Front-end acts as client to [GitHub GraphQL API v4](https://developer.github.com/v4/) (rather than REST)
  * Styling leverages [Sassy CSS](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#syntax) (rather than bare CSS3)

### Prerequisites

Programatically, the command-line environment for installation requires:

  * [Ruby (>= v2.3.1)](https://www.ruby-lang.org/en/documentation/installation/)

**NOTE:** Additionally, this application requires that your [github personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) be visible as an environment variable `GITHUB_ACCESS_TOKEN` to your Ruby interpreter environment. 

Alternatively, you may set the `GITHUB_ACCESS_TOKEN` directly in [github.rb](lib/github.rb).

Please ensure this token has the `public_repo` scope required to manage starred GitHub repositories.

### Setup

From the project directory:

* Install required gems via `bundle install`
* Instantiate a local server instance of the application via `rails server`

### Usage

Our web app should now be available at [http://localhost:3000](http://localhost:3000).

From this web interface, it should be possible to search Github repositories, favourite repos, and manage favourites.
