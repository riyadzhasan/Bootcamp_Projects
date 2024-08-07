#installs and loads packages
install.packages("tidyverse")
install.packages("plotly")
install.packages("geomtextpath")
library(tidyverse)
library(plotly)
library(geomtextpath)

#scatter of petal length and width, by species
plw <- ggplot(iris, aes(x = petal_width, y = petal_length, color = species))+
  geom_point(size=1)+
  geom_labelsmooth(aes(label = species), fill = "white", #creates labelled trend line for each group i.e. species
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) 
  labs(title="Petal length vs width",
       x="petal width",
       y="petal length"
  )
plot(plw)

#scatter of sepal length and width
slw <- ggplot(iris, aes(x = sepal_width, y = sepal_length, color = species))+
    geom_point(size=1)+
    geom_labelsmooth(aes(label = species), fill = "white", #creates labelled trend line for each group i.e. species
                     method = "lm", formula = y ~ x,
                     size = 3, linewidth = 1, boxlinewidth = 0.4) 
  labs(title="Sepal length vs width",
       x="Sepal width",
       y="Sepal length"
  )
plot(slw)

#boxplot of petal length and width, by species
box <- ggplot(iris, aes(x=petal_width, y=petal_length, fill=species))+
  geom_boxplot(alpha=0.5)+
  geom_jitter(color="black", size=0.3, alpha=0.5) + #adds datapoints onto plot, jitters to prevent overlap
  scale_fill_brewer(palette="BuPu")+
  #stat_summary(fun.y=mean, geom="point", shape=20, size=1, color="red", fill="red") +
  coord_flip() #flips axis
plot(box)

#violin plot of petal length and width, faceted by species, coordinates flipped
vio<- ggplot(iris, aes(x=petal_width, y=petal_length, fill=species))+
  geom_violin(alpha=0.5)+
  geom_jitter(color="black", size=0.3, alpha=0.5) +
  scale_fill_brewer(palette="BuPu")+
  #stat_summary(fun.y=mean, geom="point", shape=20, size=1, color="red", fill="red") +
  facet_wrap(~species)
plot(vio)

#bubble plot of petal length and width with sepal length
ggplot(iris, aes(x = petal_width, y = petal_length, size = sepal_length, color = species))+
  geom_point(size=1, alpha=0.5)+
  geom_labelsmooth(aes(label = species), fill = "white",
                   method = "lm", formula = y ~ x,
                   size = 3, linewidth = 1, boxlinewidth = 0.4) 
labs(title="Petal length vs width",
     x="petal width",
     y="petal length"
)

  