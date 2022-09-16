const DecorSilent = "_IS_SIREN_SILENT";
const DecorBlip = "_IS_SIREN_BLIP";
const controlSilent = 58;
const timeoutSilent = 15;

class SirenClass {
	Initialize() {
		DecorRegister(DecorBlip, 2);
		DecorRegister(DecorSilent, 2);

		this.playerVehicle;
		this.altSiren = false;
		this.blipSiren = false;
		this.hotkeyTimeout = 0;
	}

	IsSirenMuted(vehicle) {
		return DecorGetBool(vehicle || this.playerVehicle, DecorSilent);
	}

	IsBlipSirenMuted(vehicle) {
		return DecorGetBool(vehicle || this.playerVehicle, DecorBlip);
	}

	checkForSilentSirens() {
		GetActivePlayers().forEach((index) => {
			const ped = GetPlayerPed(index);
			if (!ped)
				return;
			const playerVeh = GetVehiclePedIsUsing(ped);
			if (playerVeh) {
				if (IsVehicleSirenOn(playerVeh)) {
					DisableVehicleImpactExplosionActivation(playerVeh, this.IsSirenMuted(playerVeh));
					if (this.IsBlipSirenMuted(playerVeh)) BlipSiren(playerVeh);
				}
			}
		})
	}

	updateInterval() {
		this.playerVehicle = GetVehiclePedIsUsing(PlayerPedId());

		this.checkForSilentSirens();
	}

	updateTick() {
		if (this.playerVehicle && IsVehicleSirenOn(this.playerVehicle)) {
	
			if (IsControlPressed(1, controlSilent)) {
				this.hotkeyTimeout++;
			} else if (this.hotkeyTimeout != 0) {
				if (this.hotkeyTimeout > 0 && this.hotkeyTimeout < timeoutSilent) {
					let boolSilent = !this.IsSirenMuted();
					if (boolSilent) {
						DecorSetBool(this.playerVehicle, DecorSilent, boolSilent);
					} else {
						DecorRemove(this.playerVehicle, DecorSilent);
					}
					DisableVehicleImpactExplosionActivation(this.playerVehicle, boolSilent);
				}

				this.hotkeyTimeout = 0;
			}

			if (IsControlPressed(1, controlSilent)) {
				if (this.hotkeyWarmup < timeoutSilent) {
					this.hotkeyWarmup++;
					return;
				}

				DecorSetBool(this.playerVehicle, DecorBlip, true);
			} else if(this.hotkeyWarmup != 0) {
				DecorRemove(this.playerVehicle, DecorBlip)
				this.hotkeyWarmup = 0;
			}
		}
	}
}

const sirenClient = new SirenClass();
setInterval(() => {
	sirenClient.updateInterval();
}, 1500);

setTick(() => {
	sirenClient.updateTick();
});

on('onClientResourceStart', (r) => {
	if (r == GetCurrentResourceName()) sirenClient.Initialize();
});