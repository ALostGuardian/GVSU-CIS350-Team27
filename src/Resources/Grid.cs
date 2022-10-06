/*
 * Author: Seth Wolfgang
 *  Code inspired by https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/lessons/01.grid/
 */

using Godot;
using System;

public class Grid : Resource
{

	[Export] private Vector2 size;
	[Export] private Vector2 tileSize;
	[Export] private Vector2 halfTileSize;

	public Grid(int nRows = 1, int nCols = 1, int tileDim = 1)
	{
		this.size = new Vector2(nRows, nCols);
		this.tileSize = new Vector2(tileDim, tileDim);
		this.halfTileSize = tileSize / 2;
	}

	/**
	 * Returns the coordinates of the center of a tile
	 */
	
	public Vector2 calcMapPos(Vector2 gridPos)
	{
		return gridPos * this.tileSize + this.halfTileSize;
	}

	/**
	 * 
	 */
	
	public Vector2 calcGridCoords(Vector2 mapPos)
	{
		return (mapPos / this.tileSize).Floor();
	}

	/**
	 * Checks to see if a given object is in bounds
	 */
	
	public bool isInBounds(Vector2 cellCoords)
	{
		bool xBound = cellCoords.x >= 0 && cellCoords.x < size.x;
		bool yBound = cellCoords.y >= 0 && cellCoords.y < size.y;
		return xBound && yBound;
	}
	
	/**
	 * Brings a given object back into bounds
	 */
	
	public Vector2 bringInBounds(Vector2 gridPos)
	{

		gridPos.LimitLength(size.x - 1);
		gridPos.LimitLength(size.y - 1);
		if (gridPos.x < 0) {gridPos.x = 0;}
		if (gridPos.y < 0) {gridPos.y = 0;}

		return gridPos;
	}

	public int asIndex(Vector2 cell)
	{
		return (int)(cell.x + size.x * cell.y);
	}
	
}
