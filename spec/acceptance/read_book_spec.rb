# frozen_string_literal: true

describe 'read book' do
  let(:book_gateway) { InMemoryGateway.new }
  let(:view_books) { ViewBooks.new(book_gateway: book_gateway) }
  let(:save_book) { SaveBook.new(book_gateway: book_gateway)}
  # Fake
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
      save_book.execute({})
      books_read = book_gateway.all.first
      expect(books_read).to eq(nil)
    end

    it 'book gateway returns a book when a book is saved' do
      book_details = { title: 'To Kill A Mockingbird',  author: 'Harper Lee' }
      save_book.execute(book_details)
      books_read = book_gateway.all.first
      expect(books_read).to eq(book_details)
    end
  end

  context 'view all read books' do
    it 'returns nil when no books read' do
      view_books.execute
      books_read = book_gateway.all
      expect(books_read).to eq([])
    end

    it 'book gateway returns a book when a book is saved' do
      book1 = { title: 'To Kill A Mockingbird', author: 'Harper Lee' }
      book2 = { title: 'Mockingbird', author: 'Lee'}

      save_book.execute(book1)
      save_book.execute(book2)

      view_books.execute
      books_read = book_gateway.all
      expect(books_read).to eq([
                                 { author: 'Harper Lee', title: 'To Kill A Mockingbird' },
                                 { author: 'Lee', title: 'Mockingbird' }
                               ])
    end
  end

  context 'remote service testing' do
    it 'can return nil when empty book string passed' do
      books = GoogleBooks.search('')
      expect(books.first).to be_nil
    end

    it 'can return book author name' do
      books = GoogleBooks.search('To kill a Mockingbird')
      expect(books.first.authors).to eq('Harper Lee')
    end

    it 'can save a book name and author' do
      books = GoogleBooks.search('To kill a Mockingbird')
      author = books.first.authors

      book_details = { title: 'To Kill A Mockingbird', author: author }
      save_book.execute(book_details)
      books_read = book_gateway.all.first
      expect(books_read).to eq(book_details)
    end

    it 'book gateway returns all book' do
      add_book1 = GoogleBooks.search('To kill a Mockingbird')
      book1_details = add_book1.first
      book1 = { title: book1_details.title, author: book1_details.authors }

      add_book2 = GoogleBooks.search('TDD')
      book2_details = add_book2.first
      book2 = { title: book2_details.title, author: book2_details.authors }

      save_book.execute(book1)
      save_book.execute(book2)

      view_books.execute
      books_read = book_gateway.all
      expect(books_read).to eq([
                                 { title: 'To Kill a Mockingbird', author: 'Harper Lee' },
                                 { title: 'Test-driven Development: By Example', author: 'Kent Beck' }
                               ])
    end
  end
end
