library(rayshader)
library(animation)

localtif = raster::raster('afg.tif')
elmat = matrix(raster::extract(localtif,raster::extent(localtif),buffer=1000),
               nrow=ncol(localtif),ncol=nrow(localtif))

elmat = elmat[,
              (1:ncol(elmat) > ncol(elmat)/1.45) & (1:ncol(elmat) < 3300)
              ]
elmat = elmat[
  (1:nrow(elmat) > 1500) & (1:nrow(elmat) < 2200),
  ]

elmat[320:330 + 50, 420:430 - 60] = 2000
raymat = ray_shade(elmat)
ambmat = ambient_shade(elmat)

img = elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color="blue") %>%
  add_shadow(ray_shade(elmat,zscale=3,maxsearch = 300),0.5) %>%
  add_shadow(ambmat,0.5)

animation::saveGIF({
  for(i in (1:50)/2) {
    print(i)
    img %>% 
      plot_3d(elmat,zscale=10,fov=0,theta=i,zoom=0.75,phi=45) 
    render_snapshot() 
    
  }}, movie.name = 'gif.gif', interval = 0.1, nmax = 30, 
  ani.width = 600)
