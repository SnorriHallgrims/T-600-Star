
p <- ggplot(dat, aes(x=nDel/alnLen,y=nIns/alnLen))+geom_point(aes(color=mapQual))+geom_abline(slope = 1,color='red')+coord_fixed(ratio=1)
p + labs(title='sp: {closest_state}')+
    transition_states(sp,transition_length = 3,state_length = 1) +
    ease_aes('linear')