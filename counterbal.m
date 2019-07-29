  
function trials=counterbal(samplefreq,samplepattern,testfreq,testpattern)

    length_Sample = length(samplepattern);
    
    trials=[]; % make an empty matrix to append the arranged values after each loop cycle
    
    
for qu=1:length_Sample
        
        l_and_f (1,1:length_Sample)= samplefreq(qu);
        l_and_f (2,:)= samplepattern;
        l_and_f (3,1:length_Sample)=     testfreq(qu);
        l_and_f (4,:)= testpattern;
        
        trials=[trials, l_and_f];
        
        clear l_and_f
        
end
end