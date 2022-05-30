class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to groups_path
  end

  def index
    @book = Book.new
    @user = current_user
    @groups = Group.all

  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      flash[:notice] = "You have created group successfully."
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    #current_userは、@group.usersから消されるという記述
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  #new.mail.htmlのform_withで入力された値を受け取っている
  def send_mail
    @group = Group.find(pamams[:group_id])
    group_users = @group.users
    #ContactMailerのsend_mailアクションへ渡している
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]

    ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
  end

  private

  def group_params
    params.require(:group). permit(:name, :introduction, :image_id)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
  unless @group.owner_id == current_user.id
    redirect_to groups_path
  end

  end

end
