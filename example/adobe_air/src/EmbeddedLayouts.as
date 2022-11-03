package
{
    public class EmbeddedLayouts
    {
        [Embed(source="/../assets/layouts/game.json", mimeType="application/octet-stream")]
        public static const GAME_UI:Class;

        [Embed(source="/../assets/layouts/menu.json", mimeType="application/octet-stream")]
        public static const MENU_UI:Class;

        [Embed(source="/../assets/layouts/card.json", mimeType="application/octet-stream")]
        public static const CARD_UI:Class;
    }
}
