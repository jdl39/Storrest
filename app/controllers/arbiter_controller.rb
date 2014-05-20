class ArbiterController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def new
    @arbiter = Arbiter.new
  end

  def create
    @arbiter = Arbiter.new
    @arbiter.username = params[:arbiter][:username]
    @arbiter.password = params[:arbiter][:password]
    @arbiter.password_confirmation = params[:arbiter][:password_confirmation]
    if @arbiter.save
      sign_in @arbiter
      redirect_to action: "new_story"
    else
      render 'new'
    end
  end

  def new_story
  	@node = Node.new
  end

  def create_story
  	# if session[:id] && params[:photo] #Uncomment this once logging in is allowed
  	if params[:new_story]
  		newNode = Node.new
  		newNode.parent_node = nil
  		newNode.contributor = current_contributor
  		newNode.text = params[:new_story][:text]
  		newNode.is_active = false
  		newNode.contributions_completed = false
  		newNode.ratings_completed = false
  		
  		
  		newStory = Story.new
  		newStory.arbiter = current_arbiter
  		newStory.root_node = newNode
  		newStory.title = params[:new_story][:title]
      newStory.length = params[:new_story][:length]
      newStory.contributions_per_node = params[:new_story][:num_additions]
      newStory.ratings_per_node = params[:new_story][:num_ratings]
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
    if Story.find(params[:id]).arbiter != current_arbiter
      redirect_to action: 'owned'
    end
    @nodes = Node.where(parent_story: params[:id], is_active: true)
  end

  # TODO: To kill a node, set node.is_active = false, node.contributions_completed = true, node.ratings_completed = true.
  # To pass a node to the next iteration, set node.is_active = false, node.contributions_completed = false (ratings_completed stays true)
  # When passing a node, use node.length_of_story_so_far to determine if the story should be over (mark node.is_story_ending = true, but kill the node.)
  # When a node completes a story, we need to get the arbiter to add a completed-story title to it (node.completed_story_title)
  def trimPost
    selected_nodes = params[:selected_nodes]
    nodes_to_kill = params[:nodes] - selected_nodes
    nodes_to_kill.each do |n|
      Node.find(n).kill
    end
    selected_nodes.each do |n|
      Node.find(n).keep
    end


    puts "Selected Nodes: ", params.to_s
    redirect_to(:action => :new)
  end

  def owned
    @stories = current_arbiter.stories
  end

  private
    def require_login
      unless signed_in?
        redirect_to controller: 'sessions', action: 'new'
      end
    end
end
