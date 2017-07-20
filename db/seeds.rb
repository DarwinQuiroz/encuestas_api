# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(email: "darquiroz@gmail.com", uid: "adawdq2esasc", provider: "github")

poll = MyPoll.create(title: "El mejor lenguaje de programación", 
					description: "Queremos saber que lenguaje de programacion consideran que esl el mejor a la hora de desorrollar una aplicacion", 
					expires_at: DateTime.now + 1.year, user: user)

question = Question.create(description: "Es mejor ruby qoe python?", my_poll: poll)

answer = Answer.create(description:"a) depende de la aplicion a desarrollar", question: question)