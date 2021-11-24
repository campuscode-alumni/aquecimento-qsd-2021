class Category
  attr_reader :title, :id

  @@next_index = 1

  def initialize(title:)
    @id = @@next_index
    @title = title
    @@next_index += 1
  end

  CATEGORIES = [
    new(title: 'Ruby'),
    new(title: 'Rails'),
    new(title: 'HTML')
  ]

  def to_s
    "##{id} - #{title}"
  end

  def self.all
    CATEGORIES
  end

  def self.index(number)
    CATEGORIES[number]
  end
end