class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all( :order => :name)

    respond_to do |format|
      format.html { render :action => 'index', :locals =>{:activated=>false} } # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @users = User.all( :order => :name)

    respond_to do |format|
      format.html  { render :action => 'index', :locals =>{ :activated=>@users.index(@user) } } # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.xml  { render :xml => @user }
      format.js { render :action => 'dialog', :locals =>{:dialog=>'new'} }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.js { render :action => 'dialog', :locals =>{:dialog=>'edit'} }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @activated = User.count

    respond_to do |format|
      if @user.save
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.js
      else
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js { render :action => 'dialog', :locals =>{:dialog=>'new'} }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    p =params[:user].clone
    if p[:password].blank? and p[:password_confirmation].blank?
      p.delete(:password)
      p.delete(:password_confirmation)
    end

    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(p) #params[:user]
        format.js
        format.xml  { head :ok }
      else
        format.js { render :action => 'dialog', :locals =>{:dialog=>'edit'} }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
