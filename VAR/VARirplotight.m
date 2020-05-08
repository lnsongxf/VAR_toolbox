function VARirplotight(IRF,VARopt,INF,SUP)
% =======================================================================
% Plot the IRFs computed with VARir
% =======================================================================
% VARirplot(IRF,VARopt,vnames,INF,SUP)
% -----------------------------------------------------------------------
% INPUT
%   - IRF(:,:,:) : matrix with periods, variable, shock
%   - VARopt: options of the VAR (see VARopt from VARmodel)
% -----------------------------------------------------------------------
% OPTIONAL INPUT
%   - INF: lower error band
%   - SUP: upper error band
% =======================================================================
% Ambrogio Cesa Bianchi, March 2015
% ambrogio.cesabianchi@gmail.com


%% Check inputs
%================================================
if ~exist('VARopt','var')
    error('You need to provide VAR options (VARopt from VARmodel)');
end
% If there is VARopt get the vnames
vnames = VARopt.vnames;
% Check they are not empty
if isempty(vnames)
    error('You need to add label for endogenous variables in VARopt');
end

%% Retrieve and initialize variables 
%================================================
filename = [VARopt.figname 'IRF_'];
quality  = VARopt.quality;
savefigs = VARopt.savefigs;
suptitle = VARopt.suptitle;
pick = VARopt.pick;

% Initialize IRF matrix
[nsteps, nvars, nshocks] = size(IRF);

% If one shock is chosen, set the right value for nshocks
if pick<0 || pick>nvars
    error('The selected shock is non valid')
else
    if pick==0
        pick=1;
    else
        nshocks = pick;
    end
end

% Define the rows and columns for the subplots
row = round(sqrt(nvars));    % 1;
col = ceil(sqrt(nvars));     % nvars;

% Define a timeline
steps = 1:1:nsteps;
x_axis = zeros(1,nsteps);


%% Plot
%================================================

for jj=pick:nshocks           
    disp(['Impulse response to ' vnames{jj}])
    figure; 
    %FigSize(40,20)
    %FigSize(40,25)
    FigSize(40,32)
    for ii=1:nvars
        subplot(row,col,ii);
        if exist('INF','var') && exist('SUP','var')
            %shadedplot(steps,INF(:,ii,jj)',SUP(:,ii,jj)',[0.7 0.7 0.7],[0.7 0.7 0.7] ); %��Ӱ������Ҫ�Ȼ�����Ȼ�Ḳ�Ǻ��滭������
            shadedplot(steps,INF(:,ii,jj)',SUP(:,ii,jj)',[0.8 0.8 0.95],[0.75 0.75 0.95] ); %��Ӱ������Ҫ�Ȼ�����Ȼ�Ḳ�Ǻ��滭������
            hold on
            plot(steps,INF(:,ii,jj),'LineStyle',':','Color',[0.39 0.58 0.93],'LineWidth',1.5);
            hold on
            plot(steps,SUP(:,ii,jj),'LineStyle',':','Color',[0.39 0.58 0.93],'LineWidth',1.5);
            hold on
        end
        plot(steps,IRF(:,ii,jj),'LineStyle','-','Color',[0.01 0.09 0.44],'LineWidth',2);
        hold on
        plot(x_axis,'k','LineWidth',0.5);
        xlim([1 nsteps]);
        title([vnames{ii} ' to ' vnames{jj}], 'FontWeight','bold','FontSize',14); 
        grid on;
        if mod(ii,3)==0
            RemoveSubplotWhiteArea(gca, row, col, ceil(ii/col), mod(ii,col)+col);
        else
            RemoveSubplotWhiteArea(gca, row, col, ceil(ii/col), mod(ii,col)); % ȥ���հײ���
        end
    %if ii==nvars
    %    legend(shade,'68%��������')
    %end
    end
    
    if savefigs
        % Save
        FigName = [filename num2str(jj)];
        if quality
            if suptitle==1
                Alphabet = char('a'+(1:nshocks)-1);
                SupTitle([Alphabet(jj) ') IRF to a shock to '  vnames{jj}])
            end
            set(gcf, 'Color', 'w');
            export_fig(FigName,'-pdf','-png','-painters')
        else
            print('-dpng','-r100',FigName);
            orient landscape
            print('-dpdf','-bestfit','-r100',FigName);
        end
    end
end