module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def hilite(name)
    name == @ordered_by ? :hilite : ''
  end
  
end
