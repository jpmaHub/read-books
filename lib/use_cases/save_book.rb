# frozen_string_literal: true

class SaveBook
  def initialize(book_gateway:)
    @book_gateway = book_gateway
  end

  def execute(book)
    return { successful: false, errors: :no_book_to_save } if book == {}
    @book_gateway.save(book)
  end
end
