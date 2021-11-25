require_relative 'category'
require 'sqlite3'

class StudyItem
  attr_reader :title, :category, :id

  def initialize(id: nil, title:, category:, done: false, created_at: nil)
    @id = id
    @title = title
    @category = category
    @done = done
    @created_at = created_at
  end

  def done?
    @done
  end

  def done!
    @done = true
  end

  def undone?
    !@done
  end

  def to_s
    "##{id} - #{title} - #{category}#{' - Finalizada' if done?}"
  end

  def include?(term)
    title.downcase.include? term.downcase
  end

  def self.create
    print 'Digite o título do seu item de estudo: '
    title = gets.chomp
    print_study_items(Category.all)
    print 'Escolha uma categoria para o seu item de estudo: '
    category = Category.index(gets.to_i - 1)
    puts "Item '#{title}' da categoria '#{category}' cadastrado com sucesso!"
    StudyItem.new(title: title, category: category)
    db = SQLite3::Database.open 'db/database.db'
    db.execute(<<~SQL, title, category.to_s, 0)
      INSERT INTO study_items (title, category, done)
      VALUES (?, ?, ?)
    SQL
  ensure
    db.close if db
  end

  def self.all
    db = SQLite3::Database.open 'db/database.db'
    db.results_as_hash = true 
    results = db.execute("SELECT * FROM study_items")
    results
      .map { |hash| hash.transform_keys!(&:to_sym) }
      .map { |item| StudyItem.new(**item) }
  ensure
    db.close if db
  end

  def self.search(term)
    all.filter { |element| element.include?(term) }
  end

  def self.undone
    all.filter(&:undone?)
  end
end