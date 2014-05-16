class ArbiterController < ApplicationController
  before_action :require_login, except: [:about, :new, :create]

  def about
    nodes_in_need = Node.where('contributions_completed = ? or ratings_completed = ?', false, false)
    @stories = Set.new
    nodes_in_need.each do |node|
      @stories << node.parent_story
    end
  end

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
  	if params[:node]
  		newNode = Node.new
  		newNode.parent_node = nil
  		newNode.contributor = current_contributor
  		newNode.text = params[:node][:text]
  		newNode.is_active = false
  		newNode.contributions_completed = false
  		newNode.ratings_completed = false
  		
  		
  		newStory = Story.new
  		newStory.arbiter = current_arbiter
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
    if Story.find(params[:id]).arbiter != current_arbiter
      redirect_to action: 'owned'
    end
    @nodes = Node.where(parent_story: params[:id], is_active: true)
  end

  def trimPost
    a = params[:nodes]
    b = params[:selected_nodes]
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
