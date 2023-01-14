-- Author: Dawan Savage Bell
-- Date: January 13, 2023
-- Description: Data for inserting Books, Author, and, Publisher

USE HomeLibraryDB
GO

---------------------------------
-- INSERTING BOOK LIBRARY DATA --
---------------------------------

-- title, year(YYYY-MM-DD), isbn, genreID, aFirstName, aLastName, Gender, pubName

EXEC dbo.InsertFullBookDetails 'Transmetropolitan','2019','978-1-4012-8795-5',10,'Warren','Ellis','M','DC Comics'

EXEC dbo.InsertGraphicNovelBook 'Transmetropolitan 2', '2019','978-1-4012-9430-4',2,1

EXEC dbo.InsertGraphicNovelBook 'Transmetropolitan 3', '2020','978-1-77950-010-6',2,1

EXEC dbo.InsertFullBookDetails 'Sword Daughter','2018','978-1-50670-782-2',10,'Brian','Wood','M','Dark Horse Books'

EXEC dbo.InsertFullBookDetails 'Deadly Class Volume 1: Reagan Youth','2014-10-01','978-1-63215-003-5',10,'Rick','Remender','M','Image Comics' 

EXEC dbo.InsertGraphicNovelBook 'Deadly Class Volume 2: Kids of The Black Hole','2021-03-01','978-1-63215-222-0',4,3

EXEC dbo.InsertGraphicNovelBook 'Deadly Class Volume 3: The Snake Pit','2015-10-01','978-1-63215-476-7',4,3

EXEC dbo.InsertGraphicNovelBook 'Deadly Class Volume 4: Die For Me','2019-03-01','978-1-63215-718-8',4,3

EXEC dbo.InsertGraphicNovelBook 'Deadly Class Volume 5: Carousel','2017-03-01','978-1-5343-0055-2',4,3

EXEC dbo.InsertGraphicNovelBook 'Deadly Class Volume 6: This is Not The End','2017-12-01','978-1-5343-0247-1',4,3

EXEC dbo.InsertAuthor 'Brian', 'Vaughan','M'

EXEC dbo.InsertGraphicNovelBook 'Saga Volume: One','2016-07-01','976-1-60706-601-9',5,3

EXEC dbo.InsertGraphicNovelBook 'Saga Volume: Two','2017-10-01','976-1-60706-692-7',5,3

EXEC dbo.InsertGraphicNovelBook 'Saga Volume: Three','2014-12-01','976-1-60706-931-7',5,3

EXEC dbo.InsertAuthor 'Gerard','Way','M'

EXEC dbo.InsertGraphicNovelBook 'The Umbrella Academy Volume Two: Dallas','2018','978-1-59582-345-8',6,2

EXEC dbo.InsertAuthor 'Scott','Snyder','M'

EXEC dbo.InsertAuthor 'Jeph','Loeb','M'

EXEC dbo.InsertGraphicNovelBook 'Batman Volume 1: The Court of Owls','2021','978-1-4012-3542-0',7,1

EXEC dbo.InsertGraphicNovelBook 'Batman: The Long Holloween','2011','978-1-4012-3259-7',8,1

EXEC dbo.InsertGraphicNovelBook 'Batman: Dark Victory','2014','978-1-4012-4401-9',8,1

EXEC dbo.InsertAuthor 'Alan','Moore','M'

EXEC dbo.InsertGraphicNovelBook 'Batman: The Killing Joke','1988','0-930289-45-5',9,1

EXEC dbo.InsertAuthor 'Frank','Miller','M'

EXEC dbo.InsertGraphicNovelBook 'Batman: Year One','2005','978-1-4012-0752-6',10,1

EXEC dbo.InsertFullBookDetails 'Ovid Metamorphoses','1983','0-253-20001-6',38,'Rolfe','Humphries','M','Indiana University Press'

EXEC dbo.InsertFullBookDetails 'Silver Arrows','1930',NULL,30,'Noel','Wilcox','M','Weeks Printing Co'

EXEC dbo.InsertFullBookDetails 'The Aeneid Virgil','1990-06-01','0-679-72952-6',38,'Robert','Fitzgerald','M','Vintage Classics'

EXEC dbo.InsertPoetryBook 'John Keats and Percy Bysshe Shelley Complete Poetical Works', '1932',NULL,15,7

EXEC dbo.InsertFullBookDetails 'Essential Bukowski','2016','98-0-06-256532-7',30,'Abel','Debritto','M','HarperCollins'

EXEC dbo.InsertPoetryBook 'Love is A Dog From Hell','2003','0-87685-362-9',1,9

EXEC dbo.InsertPoetryBook 'Sifting Through The Madness For The Word, The Line, The Way','2004','0-06-052735-8',1,9

EXEC dbo.InsertFullBookDetails 'Gather The Tide: An Anthology of Contemporary Arabian Gulf Poetry','2011','978-0-86372-375-9',30,'Patty','Paine','F','Ithaca Press' 

EXEC dbo.InsertFullBookDetails 'Hypnerotomachia Poliphili: The Strife of Love in a Dream','2005','0-500-28549-7',9,'Joscelyn','Godwin','F','Thames & Hudson'

EXEC dbo.InsertFullBookDetails 'The Hidden way Across The Threshold','1887',NULL,39,'J.C','Street','M','Lothrop, Lee & Shepard Co.'

EXEC dbo.InsertFullBookDetails 'E.E. Cummings Complete Poems 1904-1962', '1994','978-0-87140-710-8',30,'ee','cummings','M','Liveright'