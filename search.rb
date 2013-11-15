# Gems required to make this program work

require 'edan'
require 'json'

# eq makes it so you don't have to type the whole EDANQuery.new etc
eq = EDANQuery.new('myapp', 'USER', 'PW')

# First let's do a search!
puts "Enter Search Query for SAAM"
query = gets.chomp

# Capturing and then parsing the results into JSON
res = eq.request('q=' + query + '&wt=json')
results = JSON.parse(res.body)

# Dollar sign variable for testing purposes only
$results = results

# Results has keys that allow you to get number of items that match the query
# using ["response"]["numFound"] and then converting to string
puts "The number of results found based on your query was: " + results["response"]["numFound"].to_s

# Now let's look at the results raw
puts "Press enter to see the results! (Parsed into JSON)"
throwaway = gets.chomp
puts results
puts ""
puts "Press enter to continue"
throwaway = gets.chomp

# I think this should clear the screen
puts "\e[H\e[2J"

# Continuing on to making a list. Chomp helps get the key info - listName
# which we duplicate as a List Title and an author. Currently can't accept spaces for author name
puts "Now let's make a list!"
puts "Give your list a name (<25 chars, no spaces)"
listName = gets.chomp
puts "Who created this list? (No spaces)"
listOwner = gets.chomp


# This call generates the new list. Don't forget to include &wt=json and
# a comma plus '/collectService' because we are not just searching any more
res = eq.request('sl.type=lists&sl.action=create&sl.name=' + listName + '&sl.title=' + listName + '&sl.owner=' + listOwner + '&wt=json', '/collectService')
list_info = JSON.parse(res.body)

# Dollar sign variable for testing purposes only
$list_info = list_info

# This gets the listID after we generate the list, needed for adding items later on
listID = list_info["listResults"]["lists"][0]["id"]

# Showing the List info
puts ""
puts "List created. Press enter to see list info! (Parsed into JSON)"
throwaway = gets.chomp
# yourList = eq.request('sl.type=lists&sl.action=review&sl.owner=' + listOwner + '&wt=json', '/collectService')
puts list_info


# Continuing on to add an item to the list
puts ""
puts "Press enter to continue"
throwaway = gets.chomp
puts ""
puts "Let's add an item to the list. Type a search term and we'll add the first item returned in the search query to your list"
newQuery = gets.chomp

# We are doing a search query and then selecting the first item returned and
# getting the itemID and the adding that to our list
res = eq.request('q=' + newQuery + '&wt=json')
results = JSON.parse(res.body)
$results = results
newItemId = results["response"]["docs"][0]["descriptiveNonRepeating"]["record_ID"]
eq.request('sl.type=items&sl.action=add&sl.item.id=' + newItemId.to_s + "&sl.id=" + listID.to_s + "&sl.owner" + listOwner + "&wt=json", "/collectService")
puts "Item added!"
puts "Press enter to see some info about your item."
throwaway = gets.chomp

# Showing various pieces of data about the item
puts  "Item Name is: " + results["response"]["docs"][0]["descriptiveNonRepeating"]["title"]["content"]
puts  "Item Record is: " + results["response"]["docs"][0]["descriptiveNonRepeating"]["record_link"]
puts  "Url to see Item image (if there is one): " + results["response"]["docs"][0]["descriptiveNonRepeating"]["content"].to_s




