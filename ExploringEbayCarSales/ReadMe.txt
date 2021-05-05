eBay Kleinanzeigen, a classifieds section of the German eBay website, provided a dataset of used vehicles.

User orgesleka scraped the data and submitted it to Kaggle. The initial dataset is no longer accessible on Kaggle.

From the original dataset, the following changes are made:

To ensure that your code runs quickly in our hosted environment, I sampled 50,000 data points from the entire dataset.
I scuffed up the data a little to make it look more like a scraped dataset.

The following is the data dictionary that was given with the data:

a date- When this ad was crawled for the first time. This date is used to calculate all field values.
name - The car's name.
Whether the seller is a private individual or a company.
price - The price on the ad to sell the car offerType - The type of listing price
abtest - Indicates whether the listing is part of an A/B test.
vehicleType - The type of car.
yearOfRegistration - The year the car was registered for the first time.
The transmission style is known as a gearbox.
vigour
PS - The vehicle's strength in PS.
model - The name of the car model.
kilometre - The distance travelled by the vehicle.
monthOfRegistration - The month the car was registered for the first time.
fuelType - The type of fuel used by the vehicle.
brand - The car's brand name.
notRepairedDamage - If the car has a damage that hasn't been fixed yet.
dateCreated - The creation date of the eBay page.
nrOfPictures - The total number of images in the advertisement.
postalCode - The postal code for the vehicle's location.
lastSeenOnline - When this ad was last seen online by the crawler.

The aim of this project is to clean the data and analyze the included used car listings.

