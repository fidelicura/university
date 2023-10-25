use bevy::prelude::*;

use crate::fruit::Fruit;

#[derive(Debug, Component)]
pub(crate) struct Player;

impl Player {
    pub(crate) fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
        let texture = asset_server.load("player/player_static.png");
        let sprite = Sprite {
            custom_size: Some(Vec2::new(150., 150.)),
            ..default()
        };
        let position = Transform::from_xyz(0., -200., 1.);

        commands.spawn((
            SpriteBundle {
                sprite,
                transform: position,
                texture,
                ..default()
            },
            Player,
        ));
    }

    pub(crate) fn movement_handler(
        mut player_query: Query<(&mut Transform, &Player)>,
        input: Res<Input<KeyCode>>,
        time: Res<Time>,
    ) {
        player_query.iter_mut().for_each(|(mut transform, _)| {
            let movement_amount = 200. * time.delta_seconds();

            if input.pressed(KeyCode::D) {
                transform.translation.x += movement_amount;
            }

            if input.pressed(KeyCode::A) {
                transform.translation.x -= movement_amount;
            }
        });
    }

    pub(crate) fn hit_fruit(
        mut commands: Commands,
        mut fruit_query: Query<(Entity, &Transform), With<Fruit>>,
        player_query: Query<&Transform, With<Self>>,
        mut score: ResMut<PlayerScore>,
    ) {
        if let Ok(player_transform) = player_query.get_single() {
            fruit_query
                .iter_mut()
                .for_each(|(fruit_entity, fruit_transform)| {
                    let distance = player_transform
                        .translation
                        .distance(fruit_transform.translation);

                    if distance <= 80. {
                        commands.entity(fruit_entity).despawn();
                        score.amount += 1;
                    }
                });
        }
    }
}

#[derive(Debug, Resource)]
pub(crate) struct PlayerScore {
    pub(crate) amount: u16,
}

impl PlayerScore {
    pub(crate) fn new(amount: u16) -> Self {
        PlayerScore { amount }
    }
}
