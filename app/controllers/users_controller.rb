class UsersController < ApplicationController

  # GET /users
  # GET /users.xml
  def index
    @users = dry_manage_selection

    respond_to do |format|
      format.html { render :action => 'index', :locals =>{:activated=>false} } # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @users = dry_manage_selection

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
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'edit'} }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    unless current_user.privilege?(:manage_users)
      head :forbidden
      return
    end

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        dry_update_privs params
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.js { render :template => 'shared/create', :locals =>{:templ=>'user'} }
      else
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'new'} }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.id != current_user.id and ! current_user.privilege?(:manage_users)
      head :forbidden
      return
    end

    p =params[:user].clone
    if p[:password].blank? and p[:password_confirmation].blank?
      p.delete(:password)
      p.delete(:password_confirmation)
    end

    p.delete(:active) unless current_user.privilege?(:manage_users)

    respond_to do |format|
      if @user.update_attributes(p) #params[:user]
        dry_update_privs( params ) if @user.id != current_user.id and current_user.privilege?(:manage_users)
        format.js { render :template => 'shared/update', :locals =>{:templ=>'user', :item=>@user} }
        format.xml  { head :ok }
      else
        format.js { render :template => 'shared/dialog', :locals =>{:dialog=>'edit'} }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    @user.notes.each do |note|
      note.user_id = -1
      note.working = false
      note.save
    end

    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def dry_update_privs params
     Permission.privs.each do |p|
       if params.key? "priv_#{p}"
         @user.grant( p )
       else
         @user.revoke( p )
       end
     end
  end

  def dry_manage_selection
      current_user.privilege?(:manage_users) ? User.all( :order => :name ) : User.all( :order => :name, :conditions => {:id => current_user.id} )
  end
  
end
