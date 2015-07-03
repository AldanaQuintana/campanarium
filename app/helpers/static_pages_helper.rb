module StaticPagesHelper
  def editing?
    request.path.index("/editor/") == 0
  end
end