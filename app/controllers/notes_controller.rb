class NotesController < ApplicationController

	def new
	end

	def create
    	@note = current_user.notes.build(note_params)

		@note.update(article_id: params[:article_id])

		@note.save

		redirect_to article_path(params[:article_id])
	end

	def show
		@note = Note.find(params[:id])
		render plain: @note.note_text
	end

	def destroy
	    Note.find(params[:id]).destroy
	    flash[:success] = "Note deleted"
	    redirect_to article_path(params[:article_id])
	end

	def edit
		@article = Article.find(params[:article_id])
		@note = Note.find(params[:id])
	end

	def update
	    @note = Note.find(params[:id])
	    if @note.update(note_params)
	      flash[:success] = "Note updated"
	      redirect_to article_path(params[:article_id])
	    else
	      render 'edit'
	    end
	end

private
  def note_params
    params.require(:note).permit(:article_id, :note_text, :user_id, 
    	:is_public, :note_type, :page_num, :username, :is_anon)
  end

end
