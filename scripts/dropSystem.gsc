#include maps\mp\_utility;

init()
{
    level thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
    {
		level waittill ("connected", player);
        player thread dropWeaponBind();
        player thread autoDropWeapon();
	}
}
dropWeaponBind()
{
	self endon("disconnect");
 
	setDvarIfUninitialized( "dropweapon", "<^3Weapon Name^7>" );
	self notifyOnPlayerCommand( "dropweapon", "dropweapon" );
 
	for(;;)
    {
		self waittill("dropweapon");
        dropItem = getDvar("dropweapon");

        if(dropItem == "")
            dropItem = self getCurrentWeapon();

        if(!isSubStr(dropItem, "_mp"))
            dropItem += "_mp";

        if(maps\mp\gametypes\_class::isValidWeapon(dropItem))
        {
            self DropItemEx(dropItem, self.origin, self.angles);
            /*saves the positon and spawns the weapon on roundstart @autoDropWeapon()*/
            self.pers["drop_weapon"] = dropItem;
            self.pers["drop_origin"] = self.origin;
            self.pers["drop_angles"] = self.angles;
        }
	}
}
autoDropWeapon()
{
    self waittill("spawned_player");

    if(isDefined(self.pers["drop_weapon"]))
    {
        self iPrintLn("Weapon Spawned");
        self thread DropItemEx(self.pers["drop_weapon"], self.pers["drop_origin"], self.pers["drop_angles"]);
    }
}
DropItemEx(weapon, origin, angles)
{
    if(!isDefined(origin)) 
        location = self.origin;

    if(!isDefined(angles))
        angles = self.angles;

    if(!self hasWeapon(weapon))
        self giveWeapon(weapon, 0, isSubStr(weapon, "akimbo"));

    pickup = self DropItem(weapon);
    pickup.angles = (0, angles[1] , 90);
    pickup.origin = origin + (0,0,5);
    pickup.placeholder = spawn( "script_origin", origin);
    pickup.placeholder enableLinkTo();
    pickup linkTo(pickup.placeholder);
}