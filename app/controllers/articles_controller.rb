class ArticlesController < ApplicationController
  def index
    @page = params[:page] || 1
    @articles = Article.order(id: :desc).page(@page).per(10)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_url, notice: 'Article was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:url)
    end
end
