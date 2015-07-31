class SourceFetcher < ResqueJob

  def format_body p_elements
    # formatea nodos html convirtiendolos a texto con newlines
    p_elements.map(&:text)*"\n"
  end

end
