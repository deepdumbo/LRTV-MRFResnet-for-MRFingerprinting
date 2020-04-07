function [Net] = model_trainer(train_x, train_y,modelname)
%
% The MRFResnet encoder-decoder model proposed in 
%
%     M. Golbabaee, G. Bounincontri, C. Pirkl, M. Menzel, B. Menze, 
%     M. Davies, and P. Gomez. "Compressive MRI quantification using convex
%     spatiotemporal priors and deep auto-encoders." arXiv preprint arXiv:2001.08746 (2020).
%
% (c) 2018-2020 Mohammad Golbabaee, m.golbabaee@bath.ac.uk
%%

switch modelname
    case 'Encoder'
       layers= MRFResnet(10, 10, 10, 6, 1);
        
        opts= trainingOptions('adam', ...
            'MaxEpochs',50, ... %50
            'L2Regularization',0,...
            'ExecutionEnvironment','cpu',...
            'MiniBatchSize', 100,...%80
            'InitialLearnRate', .010,...
            'LearnRateSchedule','piecewise',...
            'LearnRateDropFactor',0.8,... %.8 per 1 epochs, batch_size 100
            'LearnRateDropPeriod',1,...
            'Shuffle','every-epoch', ...
            'GradientDecayFactor',.95,...
            'Verbose',true);
        
        Net = trainNetwork(train_x,train_y,layers,opts);
        
    case 'Decoder'
        
        layer = [
            imageInputLayer([1 1 2])
            convolution2dLayer(1, 300,'Padding',0)
            reluLayer
            convolution2dLayer(1, 10,'Padding',0)
            regressionLayer
            ];

        opts= trainingOptions('adam', ...
            'MaxEpochs',100, ...            %100
            'ExecutionEnvironment','cpu',...
            'L2Regularization',0,...
            'MiniBatchSize', 20,...
            'InitialLearnRate', .01,...
            'LearnRateSchedule','piecewise',...
            'LearnRateDropFactor',0.95,... %.8 per 1 epochs, batch_size 100
            'LearnRateDropPeriod',1,...
            'Shuffle','every-epoch', ...
            'GradientDecayFactor',.95,...
            'Verbose',true);
   
        Net = trainNetwork(train_x,train_y,layer,opts);
end

