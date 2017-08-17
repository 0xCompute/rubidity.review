# encoding: utf-8


get '/beer/:key' do |key|

  if ['r', 'rnd', 'rand', 'random'].include?( key )
    # special key for random beer
    # Note: use .first (otherwise will get ActiveRelation not Model)
    beer = Beer.rnd.first
  else
    beer = Beer.find_by_key!( key )
  end
end


get '/brewery/:key' do |key|

  if ['r', 'rnd', 'rand', 'random'].include?( key )
    # special key for random brewery
    # Note: use .first (otherwise will get ActiveRelation not Model)
    brewery = Brewery.rnd.first
  else
    brewery = Brewery.find_by_key!( key )
  end
end
