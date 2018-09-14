class SaveBook
  def initialize(book_gateway:)
    @book_gateway = book_gateway
  end

  def execute(book)
    return false if book == {}
    @book_gateway.save(book)
  end
end