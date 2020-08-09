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
		if current_user.nil?
			@notes = nil
		else
			@notes = @article.notes.where(user_id: current_user.id, is_public: false)\
						.order(:page_num)
		end

		@public_notes = @article.notes.where(is_public: true)\
						.order(:page_num)
		# think need to modify this (find_by_sql) to include array of comments for each public note?

		@query = params[:query]
	end
 
private
  def article_params
    params.require(:article).permit(:url, :title, :download_link)
  end

end