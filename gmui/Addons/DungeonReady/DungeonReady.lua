local lastbgs = {};

function DungeonReady_OnLoad()
  DungeonReadyFrame:RegisterEvent("LFG_PROPOSAL_SHOW");
  DungeonReadyFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
  DungeonReadyFrame:RegisterEvent("BATTLEFIELD_MGR_ENTRY_INVITE");
end

function DungeonReady_PlaySound(which) 
	PlaySoundFile(which,"Master");
end

function DungeonReady_OnEvent(self, event, ...)
 
  if(event == "LFG_PROPOSAL_SHOW") then
	DungeonReady_PlaySound("Interface\\Addons\\MyMedia\\LSM\\sounds\\dungeonready.ogg");
  elseif(event == "BATTLEFIELD_MGR_ENTRY_INVITE") then
	DungeonReady_PlaySound("Interface\\Addons\\MyMedia\\LSM\\sounds\\dungeonready.ogg");
  
  elseif(event == "UPDATE_BATTLEFIELD_STATUS") then
	for i=1, 2 do
		queueStatus, queueMapName, queueInstanceID = GetBattlefieldStatus(i);
		if ( queueStatus == "confirm" ) then
			if(lastbgs[queueMapName] and time()-lastbgs[queueMapName] <90) then
				return;
			else
				lastbgs[queueMapName] = time();
				DungeonReady_PlaySound("Interface\\Addons\\MyMedia\\LSM\\sounds\\dungeonready.ogg");
				return;
			end
		end
	end
  end
 
end