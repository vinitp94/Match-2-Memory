class Card
  attr_reader :hidden, :face_value

  def initialize(face_value)
    @hidden = true
    @face_value = face_value
  end

  def hide
    @hidden = true
  end

  def reveal
    @hidden = false
  end

  def ==(other_card)
    self.face_value == other_card.face_value
  end

end
