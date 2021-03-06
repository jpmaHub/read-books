# frozen_string_literal: true

class ViewBooks
  def initialize(book_gateway:)
    @book_gateway = book_gateway
  end

  def execute
    return { successful: false, errors: :no_books_to_view } if @book_gateway.all.empty?
    @book_gateway.all
  end
end
