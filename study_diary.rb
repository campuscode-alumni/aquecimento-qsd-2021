require 'io/console'

INSERT       = 1
VIEW_ALL     = 2
SEARCH       = 3
MARK_AS_DONE = 4
EXIT         = 5

def menu
  puts <<~MENU
    -----------------------------------------
    [#{INSERT}] Cadastrar um item para estudar
    [#{VIEW_ALL}] Ver todos os itens cadastrados
    [#{SEARCH}] Buscar um item de estudo
    [#{MARK_AS_DONE}] Marcar um item como concluído
    [#{EXIT}] Sair
    -----------------------------------------
  MENU
  print 'Escolha uma opção: '
  gets.to_i
end

def create_study_item
  print 'Digite o título do seu item de estudo: '
  title = gets.chomp
  print 'Digite a categoria do seu item de estudo: '
  category = gets.chomp
  puts "Item '#{title}' da categoria '#{category}' cadastrado com sucesso!"
  { title: title, category: category, done: false }
end

def clear
  system 'clear'
end

def wait_keypress
  puts
  puts 'Pressione qualquer tecla para continuar'
  STDIN.getch
end

def wait_and_clear
  wait_keypress
  clear
end

def print_study_items(collection)
  collection.each.with_index(1) do |item, index|
    puts "##{index} - #{item[:title]} - #{item[:category]}#{' - Finalizada' if item[:done]}"
  end
  puts 'Nenhum item encontrado' if collection.empty?
end

def search_study_items(collection)
  print 'Digite uma palavra para procurar: '
  term = gets.chomp
  collection.filter do |item|
    item[:title].include? term
  end
end

def mark_study_item_as_done(study_items)
  not_finalized = study_items.filter { |item| !item[:done] }
  print_study_items(not_finalized)
  return if not_finalized.empty?

  print 'Digite o número que deseja finalizar: '
  index = gets.to_i
  not_finalized[index - 1][:done] = true
end

clear
puts 'Boas-vindas ao Diário de Estudos, seu companheiro para estudar!'

study_items = []
option = menu

loop do
  case option
  when INSERT
    study_items << create_study_item
  when VIEW_ALL
    print_study_items(study_items)
  when SEARCH
    found_items = search_study_items(study_items)
    print_study_items(found_items)
  when MARK_AS_DONE
    mark_study_item_as_done(study_items)
  when EXIT
    break
  else
    puts 'Opção inválida'
  end
  wait_and_clear
  option = menu
end

puts 'Obrigado por usar o Diário de Estudos'
