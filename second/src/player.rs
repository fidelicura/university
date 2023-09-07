use bevy::prelude::*;

#[derive(Debug, Component)]
pub(crate) struct Player {
    speed: f32,
}

impl Player {
    pub(crate) fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
        let texture = asset_server.load("player/player_static.png");
        let sprite = Sprite {
            custom_size: Some(Vec2::new(150., 150.)),
            ..default()
        };
        let position = Transform::from_xyz(0., -200., 0.);

        commands.spawn((
            SpriteBundle {
                sprite,
                transform: position,
                texture,
                ..default()
            },
            Player { speed: 200. },
        ));
    }

    fn speed(&self) -> f32 {
        self.speed
    }

    pub(crate) fn movement_handler(
        mut characters: Query<(&mut Transform, &Self)>,
        input: Res<Input<KeyCode>>,
        time: Res<Time>,
    ) {
        characters.iter_mut().for_each(|(mut transform, player)| {
            let movement_amount = player.speed() * time.delta_seconds();

            if input.pressed(KeyCode::D) {
                transform.translation.x += movement_amount;
            }

            if input.pressed(KeyCode::A) {
                transform.translation.x -= movement_amount;
            }
        });
    }

    pub(crate) fn movement_animation_handler() {}
}

#[derive(Debug, Resource)]
pub(crate) struct PlayerScore {
    amount: u16,
}

impl PlayerScore {
    pub(crate) fn new(amount: u16) -> Self {
        PlayerScore { amount }
    }
}
