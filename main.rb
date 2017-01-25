# ruby-telegram-bot v1.0 2017 (inline mode)
# Author Dmitri Korchemkin
# license that can be found in the LICENSE file.

require "./bot.rb"

token = ""
responses = {
    "/start" => "Hi, what a gemstone you want to see?",
    "actinolite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Actinolite_Portugal.jpg/240px-Actinolite_Portugal.jpg",
    "nephrite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Nephrite_jordanow_slaski.jpg/240px-Nephrite_jordanow_slaski.jpg",
    "adamite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Adamite-179841.jpg/240px-Adamite-179841.jpg",
    "aegirine" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/8336M-aegirine.jpg/250px-8336M-aegirine.jpg",
    "afghanite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Afghanite-t06-330c.jpg/240px-Afghanite-t06-330c.jpg",
    "agate" => "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Agate_banded_750pix.jpg/240px-Agate_banded_750pix.jpg",
    "dendrite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Pyrolusite_Mineral_with_Dendrite_Macro_Digon3.jpg/220px-Pyrolusite_Mineral_with_Dendrite_Macro_Digon3.jpg",
    "fire agate" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/High_Grade_Slaughter_Mountain_Arizona_Fire_Agate_Rough.jpg/320px-High_Grade_Slaughter_Mountain_Arizona_Fire_Agate_Rough.jpg",
    "chalcedony" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Chalcedony_geode.JPG/250px-Chalcedony_geode.JPG",
    "agrellite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Museo_di_mineralogia%2C_pietre_fluorescenti%2C_agrellite_3.JPG/240px-Museo_di_mineralogia%2C_pietre_fluorescenti%2C_agrellite_3.JPG",
    "albite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Albite_-_Crete_%28Kriti%29_Island%2C_Greece.jpg/240px-Albite_-_Crete_%28Kriti%29_Island%2C_Greece.jpg",
    "chrysoberyl" => "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Chrysoberyl-282796.jpg/240px-Chrysoberyl-282796.jpg",
    "Alunite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Alunite_-_USGS_Mineral_Specimens_015.jpg/240px-Alunite_-_USGS_Mineral_Specimens_015.jpg",
    "Amblygonite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Mineral_Ambligonita_GDFL032.jpg/240px-Mineral_Ambligonita_GDFL032.jpg",
    "Ametrine" => "https://en.wikipedia.org/wiki/Ametrine",
    "Amethyst" => "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Amethyst._Magaliesburg%2C_South_Africa.jpg/270px-Amethyst._Magaliesburg%2C_South_Africa.jpg",
    "Analcime" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Analcime%2C_Aegirine%2C_Natrolite-225835.jpg/240px-Analcime%2C_Aegirine%2C_Natrolite-225835.jpg",
    "Anatase" => "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Anatase_Oisans.jpg/240px-Anatase_Oisans.jpg",
    "Andalusite" => "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/AndalousiteTyrol.jpg/240px-AndalousiteTyrol.jpg",
}

bot = TelegramBot::Bot.new(token, responses)
bot.start

