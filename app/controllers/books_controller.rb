class BooksController < ApplicationController
   before_action :authenticate_user!
  def new
    @book = Book.new
    @books = Book.all
    @user = current_user
  end

    # 投稿データの保存
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def show
    @newbook = Book.new
    @books = Book.all
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
        render "edit"
    else
        redirect_to books_path
    end
  end

  def update
   @book = Book.find(params[:id])
   if @book.update(book_params)
     flash[:notice] = "Book was successfully updated."
      redirect_to books_path(@book.id)
   else
      render :edit
   end
  end

  def destroy
    @book = Book.find(params[:id])  # データ（レコード）を1件取得
    if @book.destroy
      flash[:notice] = "Book was successfully destroyed." # データ（レコード）を削除
    redirect_to books_path  #投稿一覧画面へリダイレクト
    end
  end

 # 投稿データのストロングパラメータ
  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
