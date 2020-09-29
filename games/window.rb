require 'gosu'

class GameWindow < Gosu::Window
	def initialize(width=320, height=240, fullscreen=false)
		super
		self.caption = 'hello'
		@message = Gosu::Image.from_text(
		self, login, Gosu.default_font_name, 30)
		
	end

	def draw
		@message.draw(10,10,0)
	end

	def login
	
		storedusers = ["admin", "admin1", "admin2", "admin3"]

		storeduser = storedusers[0]

		storedpassword = "asdasda"

		@question1 = Gosu::Image.from_text(
		self, 'Please enter user name', Gosu.default_font_name, 30)
		
		user = gets.to_s.chomp
	@question1 = Gosu::Image.from_text(
		self, "Please enter #{user} password?", Gosu.default_font_name, 30)

	
		userpassword = gets.to_s.chomp


		if ((user == storeduser) && (userpassword == storedpassword) &&(userpassword.length >= 7)) 


		puts "\n\nHello #{storeduser}, "+"\nThe Time TODAY is "+Time.now.strftime("%I:%M:%S %p GMT")


		initial = "Welcome to the Political Vote Aggregator. \nPlease select an option to continue\n\n 1)(Creat) \n 2)(read) \n 3)(update) \n 4)(Delete) \n 8)(Quit) Close\n\n"
		initial.each_line { |i| puts i.capitalize.strip }

		print "Please enter your choice:\n"
		option = gets.to_s.chomp

		else
		puts "illegical option"

		end
	end
	
end




window = GameWindow.new
window.show

