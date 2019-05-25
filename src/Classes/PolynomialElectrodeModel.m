classdef PolynomialElectrodeModel < plotable3D & MetaTrajectory
% PolynomialElectrodeModel - Class representing a (potentially curved) electrode
% represented by a fitted polynomial ([0,1] -> R^3)

    properties (SetObservable);
        ELECTRODE_DIAMETER = 1.27; % deprecated, use this.electrodeInfo.diameterMm
        ELECTRODE_COLOR = rgb('DodgerBlue');
        ACTIVE_CONTACT_COLOR = rgb('Gold');
        ALPHA = 0.9;
        METAL_COLOR = rgb('Silver');
        r3polynomial = [];
        referenceTrajectory = Trajectory.empty;
        electrodeInfo = [];
        activeContact = nan;
        detectedContactPositions = [];
        useDetectedContactPositions = false;
    end
    properties (Dependent)
       skeleton; 
       apprTotalLengthMm;
       contactPositions;
       activeContactPoint;
    end
    properties (Access = private)
        hStreamtube = [];
    end
    
    methods % graphical methods
        function this = PolynomialElectrodeModel(r3polynomial, electrodeInfo)
        % Function that sets the polynomial to create the electrode model
        %
        % Parameters:
        %
        %    r3polynomial:      The description of the polynomial in r3
        %    electrodeInfo:      ? 
        %
        % Returns:
        %
        %    this:              Self-Reference

            if(nargin < 2)
                disp('No Electrode Info given, assuming Medtronic 3389');
                electrodeGeometries = load('electrodeGeometries.mat');
                electrodeInfo = electrodeGeometries.electrodeGeometries(1);
            end
            if(all(size(r3polynomial)==[3 4]))
                r3polynomial = r3polynomial';
            end
            this.r3polynomial = r3polynomial;
            this.electrodeInfo = electrodeInfo;
            this.attachListeners();

        end
        function attachListeners(this)
        % Function that attaches the Listeners
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    :

            addlistener(this, 'trajectoryChanged', @this.updatePlot3D);
            addlistener(this, 'activeContact','PostSet', @this.fireTrajectoryChanged);
            addlistener(this, 'electrodeInfo','PostSet', @this.fireTrajectoryChanged);
            addlistener(this, 'useDetectedContactPositions','PostSet', @this.fireTrajectoryChanged);
            addlistener(this, 'METAL_COLOR','PostSet', @this.fireTrajectoryChanged);
            addlistener(this, 'ELECTRODE_COLOR','PostSet',@this.fireTrajectoryChanged);
            addlistener(this, 'ACTIVE_CONTACT_COLOR','PostSet',@this.fireTrajectoryChanged);
            addlistener(this, 'ALPHA','PostSet',@this.fireTrajectoryChanged);
        end

        function fireTrajectoryChanged(this, ~, ~)
        % Function that checks if the trajectory has changed
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    :          Returns the notifcation that the trajectory has changed

            this.notify('trajectoryChanged')
        end
        
        function str = toString(this)
        % Function that generates feedback about the electrode information
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    str:       Returns the display info about the electrodes

            str = ['PolynomialElectrodeModel displaying as ' this.electrodeInfo.string];
        end
        
        function point = getActiveContactPoint(this)
        % Function that gives the active contact points of the electrodes
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    point:     ?

            tPos = invPolyArcLength3(this.r3polynomial, this.electrodeInfo.ringContactCentersMm(this.activeContact));
            point = polyval3(this.r3polynomial, tPos);
        end
        
        function positions = getContactPositions(this)
        % Function that gives the contact position of the electrodes in the electrode space
        %
        % Parameters:
        %
        %    this:          Self-Reference
        %
        % Returns:
        %
        %    position:      Contact position of the electrodes

            if(this.useDetectedContactPositions && length(this.detectedContactPositions) == length(this.electrodeInfo.ringContactCentersMm))
                positions = this.detectedContactPositions;
            else
                positions = this.electrodeInfo.ringContactCentersMm;
            end
        end

        function skel = getSkeleton(this)
        % Function that ?
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    skel:      ?

            % elec length in brain is upper bounded by ca. 10cm -> stepsize < 100mm / 1000 = 0.1 mm
            evalAt = linspace(0,1,1000)'; % kind of t
            skel = polyval3(this.r3polynomial, evalAt);
        end
        
        function tipPos = getEstTipPos(this) % FIXME DEPRECATED
        % Function that returns the estimated position of the electrode tips
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    tipPos:    Position in 3D space of the electrodes

            tipPos = polyval3(this.r3polynomial,0) + (diff(this.skeleton(1:2,:)) / norm(diff(this.skeleton(1:2,:))) * -1.1); % 1.1mm from last point (as soley plastic)
        end
        
        function points = getContactPositions3D(this)
        % Function that gives the contact positions of the electrodes in a 3D space
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    points:    ?

            points = polyval3(this.r3polynomial,invPolyArcLength3(this.r3polynomial, this.contactPositions)');
        end
        
        function setActiveContact(this, contact)
        % Function that sets the active contact
        %
        % Parameters:
        %
        %    this:          Self-Reference
        %    contact:       
        %
        % Returns:
        %
        %    :

            this.activeContact = contact;
        end
        
        function apprTotalLengthMm = getApprTotalLengthMm(this)
        % Function that ?
        %
        % Parameters:
        %
        %    this:                  Self-Reference
        %
        % Returns:
        %
        %    apprTotalLengthMm:     Approximation of the total length in mm

            apprTotalLengthMm = polyArcLength3(mod.r3polynomial,0,1);
        end
        
        function setReferenceTrajectory(this, referenceTrajectory)
        % Function that ?
        %
        % Parameters:
        %
        %    this:                      Self-Reference
        %    referenceTrajectory:       Reference trajectory
        %
        % Returns:
        %
        %    :

            this.referenceTrajectory = referenceTrajectory;
        end
        
        function dists = getReferenceDistance(this)
        % Function that gets the reference Distance
        %
        % Parameters:
        %
        %    this:      Self-Reference
        %
        % Returns:
        %
        %    dists:     Reference Distance

            if(~isempty(this.referenceTrajectory))
                a = this.referenceTrajectory.entryPoint - this.referenceTrajectory.targetPoint;
                B = bsxfun(@minus, this.skeleton,this.referenceTrajectory.targetPoint');
                distVecs = arrayfun(@(x,y,z)(cross(a,[x;y;z])/norm(a)),B(:,1),B(:,2),B(:,3), 'UniformOutput', false);
                distArray = cell2mat(distVecs')';
                dists = sqrt(sum(distArray .* distArray,2));
            else
                dists = ones(length(this.skeleton),1);
            end
        end
        
        function graphicsHandle = initPlot3D(this, parentAxes)
        % Function that ?
        %
        % Parameters:
        %
        %    this:          Self-Reference
        %    parentAxes:    Axes of the plot
        %
        % Returns:
        %
        %    graphicsHandle:    ?

        % create a group object and group all plots to this "parent" handle
            graphicsHandle = hggroup('Parent', parentAxes);
            regX = this.r3polynomial(:,1);
            regY = this.r3polynomial(:,2);
            regZ = this.r3polynomial(:,3);

            contactsEndT =  invPolyArcLength3(this.r3polynomial, this.contactPositions(end)+0.75);
            evalAt = linspace(contactsEndT,1,200)'; % kind of t
            skel = polyval3(this.r3polynomial, evalAt);
            this.hStreamtube = streamtube({skel},this.electrodeInfo.diameterMm);
            
            
            %colorCurveBy =  sqrt(sum(skeleton2ndDiff.^2,2)); %curvePointsLCI'; %sqrt(sum(curvePoints2ndDiff.^2,2));
            cData = get(this.hStreamtube, 'CData');
            if(~isempty(this.referenceTrajectory)) % color by deviation to plan
                colorCurveBy = this.getReferenceDistance();
                curveCData = repmat(colorCurveBy, 1, size(cData,2)); % minus 1
                % rgbColorMap = createColorImage(curveCData,jet,min(colorCurveBy),max(colorCurveBy)); % determine RGB colormap
                rgbColorMap = createColorImage(curveCData,jet,0,5); % determine RGB colormap TODO fixed Max value ok?
                set(this.hStreamtube,'CData', rgbColorMap, 'CDataMapping', 'direct', 'EdgeColor', 'none', 'FaceColor', 'interp');
            else
                set(this.hStreamtube,'FaceColor', this.ELECTRODE_COLOR, 'FaceAlpha', this.ALPHA, 'EdgeColor', 'none');
            end
            %%rgbColorMap = createColorImage(curveCData,jet,1,50); % determine RGB colormap TODO fixed Max value ok?
            
            %set(gca, 'CLim', [0 50]); % use FIXED min Max (1..50 for abs2nddiff) to make it comparable on differten elec/patiens) FIXME
            
            %set(gca, 'CLim', [min(colorCurveBy) max(colorCurveBy)]); %% fixed...
            %set(h,'FaceColor', ELECTRODE_COLOR);
            set(this.hStreamtube,'Parent', graphicsHandle);
            
            
            %% Plot Ring Contacts 2...n in case of metal tip or 1..n in case of NON-metal tip
            % zero ==def: lower edge of the first metal part of the electrode
            if(this.electrodeInfo.zeroToFirstPeakMm == this.electrodeInfo.tipToFirstPeakMm) % electrode has metal tip that is a contact
                minRingIdx = 2;
            else
                minRingIdx = 1;
            end
            hold on;
            spacerStart = [];
            for ring=this.electrodeInfo.noRingContacts:-1:minRingIdx 
                tPos = invPolyArcLength3(this.r3polynomial, this.contactPositions(ring) - this.electrodeInfo.ringContactLengthMm/2);
                tPos2 = invPolyArcLength3(this.r3polynomial, this.contactPositions(ring) +  this.electrodeInfo.ringContactLengthMm/2);
                endMacroContact = polyval3(this.r3polynomial, tPos); 
                startMacroContact= polyval3(this.r3polynomial, tPos2);
                if(~isempty(spacerStart))
                    [C2X,C2Y,C2Z] = cylinder2P(this.electrodeInfo.diameterMm * 0.5, 30, startMacroContact, spacerStart);  % Spacer
                    C2 =surf(C2X,C2Y,C2Z, 'EdgeColor','none', 'FaceColor',this.ELECTRODE_COLOR , 'FaceAlpha', this.ALPHA);
                    set(C2,'Parent', graphicsHandle);
                end
                spacerStart = endMacroContact;
                
                [C2X,C2Y,C2Z] = cylinder2P(this.electrodeInfo.diameterMm * 0.5, 30, startMacroContact, endMacroContact);  % Contact
               % patchColors = repmat(this.ELECTRODE_COLOR, length(C2X), 1);
               % patchColors([10 20 30],:) =  repmat(this.METAL_COLOR, 3, 1);
               % C2 =surf(C2X,C2Y,C2Z, reshape([patchColors patchColors ], 2, length(C2X), 3), 'EdgeColor','none'); % directonal lead
                if(this.activeContact == ring)
                    color = this.ACTIVE_CONTACT_COLOR;
                else
                    color = this.METAL_COLOR;
                end
                C2 =surf(C2X,C2Y,C2Z, 'EdgeColor','none', 'FaceColor',color, 'FaceAlpha', this.ALPHA);
                set(C2,'ButtonDownFcn',@(~,~)(this.setActiveContact(ring)),...
                    'PickableParts','all');
                set(C2,'Parent', graphicsHandle);
            end
            
            %% First Ring Contact / Tip (consisting of cylinder and half-sphere, assumed rigid)
            % Tip is totally of non-metal for some electrodees (i.e.
            % medronic) and should therefore NOT be included in the CT ponint cloud
            % => added extra). For Boston Electrodes with Metal Tip this is the first Ring Contact FIXME: Validate this by phantom study
            sphRadius =  this.electrodeInfo.diameterMm/2; % = 0.635mm fro medtronic
            cylLength = this.electrodeInfo.ringContactLengthMm - sphRadius; % [mm]
            
            direct =  -(startMacroContact - endMacroContact);
            direct = direct / norm(direct);
            if(this.electrodeInfo.zeroToFirstPeakMm == this.electrodeInfo.tipToFirstPeakMm) % electrode has metal tip that is a contact
                if(this.activeContact == 1)
                    tipColor = this.ACTIVE_CONTACT_COLOR;
                else
                    tipColor = this.METAL_COLOR;
                end
                tPos = invPolyArcLength3(this.r3polynomial, this.contactPositions(1) + this.electrodeInfo.ringContactLengthMm/2);
                tipDistalPoint = polyval3(this.r3polynomial,tPos);
                
                tPos = invPolyArcLength3(this.r3polynomial,  this.contactPositions(1) + this.electrodeInfo.ringContactLengthMm/2 - cylLength);
                tipCylinderProximalPoint = polyval3(this.r3polynomial,tPos);
                [C2X,C2Y,C2Z] = cylinder2P(this.electrodeInfo.diameterMm * 0.5, 30, tipDistalPoint, endMacroContact);  % Spacer
                C2 =surf(C2X,C2Y,C2Z, 'EdgeColor','none', 'FaceColor',this.ELECTRODE_COLOR, 'FaceAlpha', this.ALPHA);
                set(C2,'Parent', graphicsHandle);
            else % electrode has extra NON-metal tip
                tipColor = this.ELECTRODE_COLOR;
                tipDistalPoint = polyval3(this.r3polynomial,0);
                
                tipCylinderProximalPoint = tipDistalPoint + direct * 0.4650; %0.4650; % tip length was empircal found to be around 1.1 mm (NOT 1.5 as specified!) 1.1 - (1.27/2) = 0.4650
            end
            %Tiplength = Cylinder + Half-Sphere

            %Cylinder
            [C2X,C2Y,C2Z] = cylinder2P(sphRadius, 30, tipDistalPoint, tipCylinderProximalPoint);  % Contact

            C2 =surf(C2X,C2Y,C2Z, 'EdgeColor','none', 'FaceColor', tipColor, 'FaceAlpha', this.ALPHA);
            set(C2,'Parent', graphicsHandle);
            
            %Sphere
            [X,Y,Z]=sphere();
            fv = surf2patch(X,Y,Z);
            filterFaces = sum(ismember(fv.faces, find(fv.vertices(:,3)>0)),2)>1; % create halfsphere
            fv.faces = fv.faces(filterFaces,:);
            fv.vertices = fv.vertices * sphRadius;
            v2 = cross(direct', [5 5 5]');
            v2 = v2 / norm(v2);
            v3 = cross(direct', v2);
            v3 = v3 / norm(v3);
            M = [v2 v3 direct'];

            fv.vertices = fv.vertices * M';
            fv.vertices = bsxfun(@plus,fv.vertices ,tipCylinderProximalPoint);
            
            hTip = patch(fv, 'EdgeColor', 'none', 'FaceColor', tipColor, 'FaceAlpha', this.ALPHA); % [0.98 0.98 0.8]
            set(hTip,'Parent', graphicsHandle);
            
            this.plotHandleHashMap3D(double(parentAxes)) = double(graphicsHandle);
            
            %% Rendering Settings
            if(isempty(findobj(parentAxes, 'Type', 'light')))
                camlight headlight;
                camlight left;
            end
            
            lighting gouraud;
            daspect([1 1 1]);   
            material(graphicsHandle,'shiny');
        end     
        
        function newPolynomialElectrodeModel = applyFSLTransform(this, fslTransMat, sourceRefImage, targetRefImage)
        % Function that ?
        %
        % Parameters:
        %
        %    this:              Self-Reference
        %    fslTransMat:       ?
        %    sourceRefImage:    Source Reference Image
        %    targetRefImage:    Target Reference Image
        %
        % Returns:
        %
        %    newPolynomialElectrodeModel:    ?

            newPolynomialElectrodeModel = this.copy();
            newPolynomialElectrodeModel.plotHandleHashMap3D = containers.Map('KeyType', 'double', 'ValueType', 'double'); % get rid of potenial copied handles
            newPolynomialElectrodeModel.r3polynomial = applyFSLTransformToPolyCoeffs(this.r3polynomial, fslTransMat, sourceRefImage, targetRefImage);
            newPolynomialElectrodeModel.attachListeners();
        end
        
        function newPolynomialElectrodeModel = applyANTSTransform(this, antsTransformFileStrings)
        % Function that ?
        %
        % Parameters:
        %
        %    this:                          Self-Reference
        %    antsTransformFileStrings:      ?
        %
        % Returns:
        %
        %    newPolynomialElectrodeModel:    ?

            newPolynomialElectrodeModel = this.copy();
            newPolynomialElectrodeModel.plotHandleHashMap3D = containers.Map('KeyType', 'double', 'ValueType', 'double'); % get rid of potenial copied handles
            newPolynomialElectrodeModel.r3polynomial = applyANTSTransformToPolyCoeffs(this.r3polynomial, antsTransformFileStrings);
            newPolynomialElectrodeModel.attachListeners();
        end
    end
end

% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation