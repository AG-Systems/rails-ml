module PagesHelper
   def post_params
    params.require(:ad).permit(:title, :rating, :feedback, :author, :image)
  end
end
