require 'mysql2'

client = Mysql2::Client.new( :host => "127.0.0.1" , :username => "root" , :database => "test" )


#text = "Omar Hayssam ar putea fi adus marti la Tribunalul Bucuresti, unde se judeca un nou termen in Omar Hayssam"

text = "Omar Hayssam ar putea fi adus marti la Tribunalul Bucuresti, unde se judeca un nou termen in dosarul \"Manhattan\", in care este acuzat de savarsirea infractiunii de delapidare, prejudiciul fiind de aproximativ 20 milioane de euro, scrie Agerpres. Hayssam a fost trimis in judecata in acest dosar in octombrie 2012 de procurorii DIICOT, alaturi de fratele sau, Mohamad Omar, cumnatul lui, Mihai Nasture, si doi parteneri de afaceri, Viorel Vasile Mafteuca si Doina Farladanschi. Potrivit DIICOT, cei cinci au constituit un grup infractional organizat si au actionat premeditat si planificat in vederea nerestituirii creditelor si trecerii patrimoniilor SC Bucovina Mineral Water si SC Rio Soft Drinks SA in cadrul altor societati din \"Grupul Manhattan\". Procurorii sustin ca Hayssam si complicii lui au contractat imprumuturi bancare in numele Bucovina Mineral Water si Rio Soft Drinks SA, dupa care au transferat patrimoniile celor doua companii (fabrica de sucuri Rio din Timisoara si fabrica de imbuteliere ape minerale si sucuri Bucovina din Vatra Dornei) catre alte societati reale sau fantoma din \"Grupul Manhattan\". Prejudiciul produs este de 78,4 milioane de lei pentru infractiunea de delapidare, 4.171.261,86 de dolari, respectiv 2.295.698 de lei pentru infractiunea de evaziune fiscala, 17,3 milioane de lei pentru infractiunea de spalare a banilor, totalul fiind de aproximativ 20 milioane de euro. Omar Hayssam a fost condamnat de instantele din Romania in patru dosare: 20 de ani de inchisoare pentru rapirea jurnalistilor in Irak, 16 ani de inchisoare in dosarul \"Volvo Truck\", 3 ani de inchisoare in dosarul \"Foresta Nehoiu\", 2 ani de inchisoare pentru trecerea frauduloasa a frontierei. Primele trei condamnari sunt definitive. Hayssam a fost adus vineri dimineata in Romania."

names = text.scan(/([A-Z][\w-]*(\s+[A-Z][\w-]*)+)/).map{ |i| i.first }

#eliminam toate dublurile
names.uniq!

keywords = []

names.each do |name|
	
	found = false
	keywords.each do |key|
		res = key.scan(/#{name}/)
		if ( ! res.empty? )
			found = true
			break
		end
	end
	if ( !found )
		keywords.push( name )
	end
end

names = keywords

p names

words = text.split(/\W+/)

query = "SELECT id from lexem WHERE  ( modelType='M' OR modelType='F' OR modelType='N' OR modelType='I' ) AND `formUtf8General` LIKE '"

firstQuery = "SELECT DISTINCT lexemId from inflectedForm WHERE `formUtf8General` LIKE '"


words.each do |word|

	if ( word =~ /^[0-9]+$/ || word.length < 5 )
		next
	end

	newQuery = firstQuery + word + "'"
	#puts newQuery

	results = client.query( newQuery )

	if ( results.count == 0 )
		puts word
	end


	# if ( results.count == 0 )
	# 	#verific ca {word} sa nu se gaseasca in cuvintele pe care le am deja
	# 	found = false
	# 	names.each do |name|
	# 		res = name.scan(/#{word}/)
	# 		if ( ! res.empty? )
	# 			found = true
	# 			break
	# 		end
	# 	end

	# 	if ( ! found )
	# 		names.push( word )
	# 	end
	# else
	# 	results.each { |r| puts r }
	# end



end

p names

