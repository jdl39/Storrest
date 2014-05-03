class ArbiterController < ApplicationController
  def new
  	@node = Node.new
  end

  def create
  	# if session[:id] && params[:photo] #Uncomment this once logging in is allowed
  	if params[:node]
  		newNode = Node.new
  		newNode.parent_node = nil
  		#newNode.contributor = session[:username]
  		newNode.text = params[:node][:text]
  		newNode.is_active = true
  		newNode.contributions_completed = false
  		newNode.ratings_completed = false
  		
  		
  		newStory = Story.new
  		#newStory.arbiter = session[:id]
  		newStory.root_node = newNode
  		newStory.title = params[:node][:contributor]
  		newStory.complete = false
  		
  		newNode.parent_story = newStory
  		newNode.save
  		newStory.save
  		redirect_to(:action => :share, :id => newStory.id)
  	else
  		redirect_to(:action => :new)
  	end
  end

  def share
  	@story = Story.find(params[:id])
  end

  def trim
  end

  def login
  end

  def owned
  end
end
