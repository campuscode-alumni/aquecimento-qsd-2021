require 'io/console'

def welcome
  'Boas-vindas ao Diário de Estudos, seu companheiro para estudar!'
end

def menu
  puts <<~MENU
    -----------------------------------------
    [1] Cadastrar um item para estudar
    [2] Ver todos os itens cadastrados
    [3] Buscar um item de estudo
    [4] Marcar um item como concluído
    [5] Sair
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
  system('clear')
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

clear
puts welcome

study_items = []
option = menu

while option != 5
  if option == 1
    study_items << create_study_item
    wait_and_clear
  elsif option == 2
    study_items.each.with_index(1) do |item, index|
      puts "##{index} - #{item[:title]} - #{item[:category]}#{' - Finalizada' if item[:done]}"
    end
    puts 'Nenhum item cadastrado' if study_items.empty?
    wait_and_clear
  elsif option == 3
    print 'Digite uma palavra para procurar: '
    term = gets.chomp
    found_items = study_items.filter do |item|
      item[:title].include? term
    end
    puts found_items
    puts 'Nenhum item encontrado' if found_items.empty?
    wait_and_clear
  elsif option == 4
    not_finalized = study_items.filter { |item| !item[:done] }
    not_finalized.each.with_index(1) do |item, index|
      puts "##{index} - #{item[:title]} - #{item[:category]}#{' - Finalizada' if item[:done]}"
    end
    if study_items.empty?
      puts 'Nenhum item encontrado'
    else
      print 'Digite o número que deseja finalizar: '
      index = gets.to_i
      not_finalized[index.to_i - 1][:done] = true
    end
    wait_and_clear
  else
    puts 'Opção inválida'
    wait_and_clear
  end
  clear
  option = menu
end

puts 'Obrigado por usar o Diário de Estudos'
