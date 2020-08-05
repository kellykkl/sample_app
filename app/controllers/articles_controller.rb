class ArticlesController < ApplicationController
	require 'nokogiri'
	require 'open-uri'

	def new
		render '/static_pages/home'
	end

	def create
	  @article = Article.new(article_params)
	 
	 # if not existing, create. else, just redirect
	 existing = Article.where(:url => @article.url).first
	 if existing.nil?
	  
		  doc = Nokogiri::HTML(open(@article.url))
		  title = doc.xpath('/html/head/meta[@name="citation_title"]/@content').to_s
		  download_link = doc.xpath('/html/head/meta[@name="citation_pdf_url"]/@content').to_s

		  puts title
		  puts download_link

		  @article.update(title: title, download_link: download_link)


		  @article.save
		  redirect_to @article
	 else
	 	redirect_to existing
	 end

	end

	def show
		@article = Article.find(params[:id])
		@notes = @article.notes.where(user_id: current_user.id, is_public: false)\
					.order(:page_num)
	end
 
private
  def article_params
    params.require(:article).permit(:url, :title, :download_link)
  end

end