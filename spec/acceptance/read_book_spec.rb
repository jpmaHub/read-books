describe 'read book' do
 let(:file_book_gateway) { FileBookGateway.new }
  context 'saving read books' do

    it 'returns no books when nil passed' do
     save_book = SaveBook.new(book_gateway: file_book_gateway)
     save_book.execute({})
     books_read = file_book_gateway.all
     expect(books_read).to eq([])
    end 
  end 
end 