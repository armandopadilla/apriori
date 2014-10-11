##########
# Apriori Algorithm Implementation
#
# @author Armando Padilla, armando_padilla_81@yahoo.com 
# @homepage http://www.armando.ws
#
# v0.0.2 month.week.day
##########

#require ‘profiler’
#Profiler__::start_profile
start = Time.now
puts “Started – “+start.to_s

#############
# Create the new list (Lk) for the next iteration
#
# @param itemSets Lk-1 list that has been cleared out of all
# none frequent sets.
#############
def createList(itemSets)

###
# HOLDS THE NEW LIST
###
listX = Array.new()

if !itemSets.nil?

#Check if the initial elements are the same
#if they are the same then
#Check if the last item is less than the next row’s last item.
#if its less then join both items (union on both items)

k = 1
itemSetSize = itemSets.size

itemSets.each do |list1|

n=k
until n == itemSetSize

#Check if we can combine the lists
#if initial run yes lets combine the list
#otherwise follow the steps

if itemSets[n].size == 1

if !list1.eql?(itemSets[n])

@row = Array.new()
@row.push(list1,itemSets[n])
@row = @row.sort
@row = @row.flatten!

###
# DO NOT ADD IF WE ALREADY HAVE THE SET
###
if !listX.include?(@row)
listX.push(@row)
end

end

else

####
#if the all the indexes before the last are the same
#then combine ONLY IF the last indexes are the same
####
toIndex = list1.size-2

###
# GET ALL THE VALUES UP TO THE LAST INDEX
# EG. [1,2,3,4,5] and [1,2,3,4,6]
# BECOMES [1,2,3,4] and [1,2,3,4]
###

arrayA = list1[0..toIndex]
arrayB = itemSets[n][0..toIndex]

if arrayA.eql?(arrayB)

totalCountA = list1.size-1
totalCountB = itemSets[n].size-1

if list1[totalCountA] < itemSets[n][totalCountB]

@row = Array.new()
@row.push(list1|itemSets[n])
@row = @row.sort.uniq
@row = @row.flatten!

###
# DO NOT ADD IF WE ALREADY HAVE THE SET
###
if !listX.include?(@row)
listX.push(@row)
end

end

end
#puts “=========”

end

n = n+1
end

k = k+1
end

end

return listX

end

##############
# Returns the item sets that support the minimum supporting threshold.
#
##############
def getFrequentItemSets(itemSets, minSup, fileInputPath)

########
# RUNS THROUGH THE DATA SET AND GETS THE COUNT
######
list = Array.new()

##
# FOREACH ITEM CHECK HOW MANY TIMES IT APPEARS IN THE DATA SET
##
itemSets.each do |itemSet|

itemSetSize = itemSet.size
count = 0

###
# FOR EACH ROW IN THE ITEM SET
# RUN THROUGH EACH ROW IN THE DATA SET
# AND DETERMINE IF THE ITEM SET APPEARS IN THE RECORD
###
@dataSet.each do |set|

currentRow = set

if itemSetSize == 1

if currentRow.index(itemSet[0])
count = count+1
end

else

###
# FOR EACH ROW CHECK IF THE ITEMSET IS PRESENT
#
# ARMANDO – USING INTERSECTION TO COMPARE
# =======================================
# ITEMSET = A
# CURRENT ROW = B
# TAKE THE INTERSECTION OF A AND B
# IF SIZE OF INTERSECTION IS EQUAL TO SIZE OF ITEMSET THEN
# WE LOCATED THE ITEM SET IN THE ROW
###

intersection = []
itemSet.each do |a|

set.each do |b|

if a == b
intersection.push(a)
end

end

end

if intersection.size >= itemSetSize
#if (itemSet&currentRow).size >= itemSet.size

count = count+1

end

end

end #end – run through data set

###
# DETERMINE IF IT MEETS THE MIN_SUP
# if the calculatedValue is equal to or greater than the
# minimum supporting threshold ad it to our new List (L k)
###
if count >= minSup

@row = Array.new()
@row.push(itemSet)
list.push(itemSet)

string = “”
itemSet.each do |x|
string = string+” “+x.to_s
end
@file.puts string+” :”+count.to_s
@file.flush

else

irow = Array.new()
irow.push(itemSet)
@infrequentSets.push(irow)

end
p(itemSet)

end #end – run though each item

return list.sort

end #end – getFrequentItemSets

##############
# Returns boolean when the item set is either
# frequent or infrequent
##############
def isInfrequentSets(itemSets)

globalCount = 0
###
# FOREACH ITEMSET CHECK IF ITS IN THE INFREQUENT ITEM SET
###
itemSets.each do |itemSet|

count = 0
@infrequentSets.each do |itemSetX|

###
# IF WE FOUND A ITEM SET WITH at least 2 sub items
# REMOVE IT
###
if(itemSet&itemSetX[0]).size >= 2
count = count+1
end

end

if count != 0
globalCount = globalCount + 1
end

end

if globalCount == itemSets.size

return true

end

end

#####
# Reads the input from a text file and create an array
# Each line is an array of elements.
# Elements broken out by white space.
#
# @param fileInputPath Path to data set file.
#
####
def getDataSet(fileInputPath)

dataSet = []

if File.exists?(fileInputPath)

###
# GET THE FILE CONTENT
###
dataContainer = File.open(fileInputPath, “r”)

###
# FOREACH LINE BREAK APART BY WHITESPACE
# AND PLACE INTO ARRAY
###
flist = []
dataContainer.readlines.each do |line|

flist.push(line)

end

flist.each do |line|

elements = line.split(” “)

row = Array.new()

elements.each do |element|

row.push(element.to_i)

if @globalHash[element.to_i] != nil
@globalHash[element.to_i] = @globalHash[element.to_i]+1
else
@globalHash[element.to_i] = 1
end

end

###
# ADD THE ROW AS AN ARRAY
# TO THE DATA SET
###
dataSet.push(row)

end

else

puts “Error: File, “+fileInputPath+”, does not exist”

end

return dataSet

end

#########################################################
#########################################################
#########################################################
if ARGV.size == 3

###
# INITIALIZE VARIABLES
###
min_sup = ARGV[2].to_i
fileInputPath = ARGV[0]
outputFilePath = ARGV[1]

@infrequentSets = Array.new()
@globalHash = Hash.new() #holds out initial List with counts

#####
# GET THE DATA SET FROM FILE
#####
@dataSet = Array.new()
@dataSet = getDataSet(fileInputPath)

####
# WRITE OUT THE OUTPUT
####
@file = File.open(outputFilePath, “w+”)

#####
# GET ALL THE ITEMS WITH MIN_SUP > N – List1
#####
@itemsContainer = []
@globalHash.keys.each do |element|

if @globalHash[element].to_i >= min_sup

@itemsContainer.push(element)

string = element.to_s
@file.puts string+” :”+@globalHash[element].to_s
@file.flush

end

end
@itemsContainer.sort!

####
#MAKE ALL ITEMS IN CONTAINER AN ARRAY
####
@items = Array.new()
@itemsContainer.each do |x|
@row = Array.new()
@row.push(x)
@items.push(@row)
end

@items = createList(@items)

######
# RUN THROUGH THE DATA SET UNTIL WE HAVE REACHED
# ALL FREQUENT ITEMSETS.
######
k = 1
@listK = @items

foundAllFrequentSets = FALSE
while foundAllFrequentSets == FALSE

###
# GET ALL THE ITEMS THAT PASS THE MIN_SUP THRESHOLD
###
@frequentSet = getFrequentItemSets(@listK, min_sup, fileInputPath)
p(@frequentSet)
#######
# CREATE THE NEW LIST FROM THE FRQUENT ITEMSET
# THAT MET MIN_SUP
#######
@listK = createList(@frequentSet)

#check if the result all contain infrequent sub sets
if isInfrequentSets(@listK)
foundAllFrequentSets = TRUE
end

k = k+1
end #while foundAllFrequentSets == FALSE

@file.close

else

puts “Error: Must Be Format Type :: apriori.rb

” end

endTime = Time.now
puts “Ended – “+endTime.to_s+”\n”
puts “Total Time: “+(endTime-start).to_s+”\n”

#Profiler__::stop_profile
#Profiler__::print_profile($stderr)
