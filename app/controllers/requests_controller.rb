class RequestsController < ApplicationController
	include Github

  #searches github repos for the given query
	def search
    redirect_to root_path(query: params[:query])
	end

  #adds given repo to favourites (and reload)
	def addstar
		id = params[:id]
		Github::Repo.addStar(id)
		
		redirect_to root_path(query: params[:query])
	end

  #removes given repo to favourites
	def removestar
		id = params[:id]
		Github::Repo.removeStar(id)
		
		redirect_to root_path(query: params[:query])
	end

end