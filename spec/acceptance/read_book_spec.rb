describe 'read book' do
 let(:book_gateway) { InMemoryGateway.new }
  class InMemoryGateway
    def initialize
      @book = []
    end

    def all
      @book
    end 

    def save(book)
      @book.push(book)
    end 
  end
  
  context 'saving read books' do
    it 'returns nil when no books saved' do
     save_book = SaveBook.new(book_gateway: book_gateway)
     save_book.execute({})
     books_read = book_gateway.all.first
     expect(books_read).to eq(nil)
    end 

    it 'book gateway returns a book when a book is saved' do
      save_book = SaveBook.new(book_gateway: book_gateway)
      book_details = {
      title: 'To Kill A Mockingbird',
      author: 'Harper Lee'
      }
      save_book.execute(book_details)
      books_read = book_gateway.all.first
      expect(books_read).to eq(book_details)
     end
  end 

  context 'view all read books' do
    it 'returns nil when no books read' do
     view_books = ViewBooks.new(book_gateway: book_gateway)
     view_books.execute
     books_read = book_gateway.all
     expect(books_read).to eq([])
    end 

    xit 'book gateway returns a book when a book is saved' do
      save_book = SaveBook.new(book_gateway: book_gateway)
      book_details = {
      title: 'To Kill A Mockingbird',
      author: 'Harper Lee'
      }
      save_book.execute(book_details)
      books_read = book_gateway.all.first
      expect(books_read).to eq(book_details)
     end
  end 

end 