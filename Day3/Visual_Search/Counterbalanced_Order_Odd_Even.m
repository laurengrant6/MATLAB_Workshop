function [a] = CounterbalancedOrder(nTrialTypes, nTrials)
%This script generates a first-order counterbalanced trial sequences for
%nTrialTypes and nTrials
%Further, it separately counterbalances odd- and even-numbered trials
%Thus, the number of trials in each run needs to be a multiple of 2*nTrialTypes^2

%Allows us to start over if the program gets stuck
repeatvar =1;

while repeatvar==1
  
    %First, we define an n by n matrix, where n=# of trial types to be randomized.  
    %Each number in the matrix indicates how many times each trial type is to be followed and preceded by every trial type in the design.  
    matrix=(nTrials/(nTrialTypes*nTrialTypes)/2)*ones(nTrialTypes,nTrialTypes,2); %The 2 at the end represents the odd-even trial dimension and means that we're counterbalancing separately for odd and even trials
       
    repeatvar=0;
    
    %Calculate first trial.
    a= floor(rand(1)*nTrialTypes+1);
    
    %OK- let's pretend that the first trial really did follow another trial type.  
    %Randomly pick the previous trial type.
    prev_trial_type=[floor(rand(1)*nTrialTypes+1)];
    %Also, since this is the first trial (i.e., trial 1), it's odd. 
    current_odd_even = 1;
    
    %Decrement the appropropriate counter
    matrix(prev_trial_type, a, current_odd_even)= matrix(prev_trial_type, a, current_odd_even)-1;
    
    %Create the rest of the trial sequence 
    for counter=1:(nTrials-1);
        
        if mod (counter+1, 2) %odd-numbered trial
            
            current_odd_even = 1;
            
        else %even-numbered trial
            
            current_odd_even = 2;
            
        end
        
        post = floor(rand(1)*nTrialTypes+1);
        
      
        % check sum across the third dimension ("prev trial") to see if there are any remaining positions.
      
        if sum(matrix(a(counter),:,current_odd_even))==0; % no remaining positions     
            counter=nTrials-1;
            repeatvar=1;
            string=['WE HAVE TO REPEAT BECAUSE WE GOT STUCK!'];
            
            break
            
            
            
        else  % remaining positions
            
            
            while (matrix(a(counter), post, current_odd_even)==0) 
                post = floor(rand(1)*nTrialTypes+1);
            end
            
        end   
            
        matrix(a(counter),post, current_odd_even)= matrix(a(counter),post, current_odd_even)-1;
        
        a = [a post];
        
        
        
    end
    
end  

a;	%take off semi-colon to print choice of trial types to screen in order they were chosen

%The routine beklow checks if the counterbalancing worked. 
%I have tested this and it works.
%It's most informative to take the semicolon off of the CheckMatrix
%initialization (top) and final value at the end.
%This allows one to see the initial and final values of each cell of the counterbalancing matrix, which should be 
%Initial: nTrials/(nTrialTypes*nTrialTypes)/2
%Final: 0
%Note: older versions of this program used for Prime_Word_Flanker and
%Prime_Arrow_Flanker would crash if certain nTrialTypes values were
%entered. However, they gave correct sequences for the values in those
%experiments (2 triatypes, 96 trials). So, they were fine. However, I have
%now updated those versions with this version.

%Create a matrix of previous and current trial combinations, with separate
%identical holders for odd and even trials like above
CheckMatrix = (nTrials/(nTrialTypes*nTrialTypes)/2)*ones(nTrialTypes,nTrialTypes,2);

%Cycle through trial n-2: end
for iii = 2: nTrials
    
    %Establish whether this is an odd or even trial
    if mod(iii, 2)%odd
        Odd_or_Even = 1;
    else %even
        Odd_or_Even = 2;
    end
    
    %Decrement the appropriate cell of check matrix
    CheckMatrix(a(iii-1), a(iii), Odd_or_Even) = CheckMatrix(a(iii - 1), a(iii), Odd_or_Even) - 1;
end

%Finally decremement the "imaginary previous trial type" that we created
%for the first, odd (Odd_Or_Even =1) trial
CheckMatrix (prev_trial_type, a(1), 1) = CheckMatrix (prev_trial_type, a(1), 1)-1; 
CheckMatrix;
