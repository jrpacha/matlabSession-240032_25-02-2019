%exercise2.m: interpolate temperature on a quadrilateral mesh

%Files required:

% meshTwoHolesQuad.m:    uncompress this file from meshFilesAll.rar
% plotElements.m:        uncompress this file from additionalFiles.zip 
% plotContourSolution.m: uncompress this file from additionalFiles.zip
% baryCoordQuad.m

%Be sure they are placed in the current folder!

%You can download meshFilesAll.rar and additionalFiles.zip from 
%Toni Susin's Numerical Factory.

clearvars
close all

p=[39.0,7.0];

eval('meshTwoHolesQuad'); %load nodes position and connectivity matrices
                          %from the mesh file meshTwoHolesQuad.m 
                          
numNodes=size(nodes,1); %number of nodes
numElem=size(elem,1);   %number of elements

temp=1:numNodes; %temperatures at the nodes. Just an example!
temp=temp(:);

for e=1:numElem
    n1=elem(e,1);
    n2=elem(e,2);
    n3=elem(e,3);
    n4=elem(e,4);
    v1=nodes(n1,:);
    v2=nodes(n2,:);
    v3=nodes(n3,:);
    v4=nodes(n4,:);
    vertexs=[v1;v2;v3;v4];
    [alphas,isInside]=baryCoordQuad(vertexs,p);
    if isInside >=1
        numElemP = e;
        numNodesP = [n1,n2,n3,n4];
        nodesP = vertexs;
        %interpTemp = alphas*temp(numNodesP);
        interpTemp=temp(n1)*alphas(1)+... %Interpolates temp. at point p
            temp(n2)*alphas(2)+...
            temp(n3)*alphas(3)+...
            temp(n4)*alphas(4);
        break;
    end
end

%Draw the mesh, and mark the point p and its element's nodes
figure()
plotElements(nodes, elem,0);
hold on
plot(p(1,1),p(1,2),'or','Marker','o','MarkerFaceColor','red',...
    'MarkerSize',5)
plot(nodesP(:,1),nodesP(:,2),'og','Marker','o','MarkerFaceColor',...
    'green','MarkerSize',4)
hold off 

%Color map for the temperatures (optional for this practice)
titol='Temperature plot';
colorScale='jet';
plotContourSolution(nodes,elem,temp,titol,colorScale)
hold on
plot(p(1,1),p(1,2),'ok','Marker','o','MarkerFaceColor','black',...
    'MarkerSize',4)
plot(vertexs(:,1),vertexs(:,2),'ok','Marker','o','MarkerFaceColor',...
    'black','MarkerSize',4)
hold off
                     
%Fancy output with fprintf: don't try this at exams!
fprintf('--------------------------------------------------\n')
fprintf('Fancy output: don''t try this at the exams!\n')
fprintf('Elem.: %d\n',numElemP)
fprintf('Nodes: %d,%d,%d,%d\n',numNodesP)
fprintf('%20s\n','Vertexs Coords.')
fprintf('%7s%11s\n','X','Y')      
fprintf('%12.5e%12.5e\n',nodesP')
fprintf('\nInterpolated Temp.at point p=(%f,%f):\nT=%12.5e\n',...
    p,interpTemp);
fprintf('--------------------------------------------------\n')

%An straightforward way to print the results:
fprintf('\nAn straightforward way to get the results...\n')
format short e
numElemP
numNodesP
nodesP
p
interpTemp