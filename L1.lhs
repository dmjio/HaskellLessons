First Meet-Up

Know types, know haskell, no types, no haskell

-- Taste of concurrency

-- The main thread of execution (OS Thread) says "running" every three
-- seconds

-- The forked thread of execution receives command line input and immediately writes it to the console (stdout)

> import           Control.Concurrent
> import           Control.Monad
> import           Text.Read

> secs :: Int -> Int
> secs = (*1000000)

> concurrentProgramming :: IO ()
> concurrentProgramming = do
>  forkIO $ forever $ do
>         line <- getLine
>         putStrLn line
>  forever $ do
>         threadDelay (secs 2)
>         putStrLn "running..."

-- NewType vs. Data
-- Newtype gives you type safety without boxing at runtime, the only limitation is that only one constructor is allowed
-- Data boxes at runtime, allows you to define multiple constructors

newtype StripeKey String = StripeKey "my key"

-- Algebraic Data Types 
> data MyNums = One | Two | Three 

-- We did not discuss this, but there are Sum Types vs. Product Types
-- Follow up reading: http://chris-taylor.github.io/blog/2013/02/10/the-algebra-of-algebraic-data-types/
-- video: https://www.youtube.com/watch?v=YScIPA8RbVE

-- What is :t One, Two, Three --> ?
-- What happens if you do :i MyNums --> ? 

-- Typeclass introduction... What is a typeclass?
-- What is ad hoc polymorphism

-- Typeclasses

What is a typeclass? 

> class ToString a :: * where
>    to_str :: a -> String

A typeclass is conceptually similar to a Java interface. Any typeclass that is defined can be instanced by a Type if the kinds align. Classes can inherit from one another.

Example:

-- class Eq a => Ord a where

What is a kind? A kind is the type of a type (These will be important when we get to monad transformers)

-- Types have kinds

> instance ToString MyNums where
>    to_str One = "one"
>    to_str Two = "two"
>    to_str Three = "three"

> instance Eq MyNums where
>    One == One = True
>    Two == Two = True
>    Three == Three = True
>    _ == _ = False

-- Define (<=) instances
> instance Ord MyNums where
>    One < Two   = True
>    One < Three = True
>    Two < Three = True
>    _ < _ = False
>    a > b = not (a < b)

-- Quizzes
-- Define : ($) (.) foldr, foldl, map, filter

> ($) :: (a -> b) -> a -> b
> ($) f x = f x

> (.) :: (b -> c) -> (a -> b) -> a -> c
> (.) f g x = f (g x)

> foldr :: (a -> b -> b) -> b -> [a] -> b
> foldr _ y [] = y
> foldr f y (x:xs) = f x (foldr f y xs)

> foldl :: (a -> b -> a) -> a -> [b] -> a
> foldl f x xs = go x xs 
>       where
>          go z [] = z
>          go z (y:ys) = go (f z y) ys

> map :: (a -> b) -> [a] -> [b]
> map _ [] = []
> map f (x:xs) = f x : map f xs

> filter :: (a -> Bool) -> [a] -> [a]
> filter _ [] = []
> filter p (x:xs)
>     | p x       = x : filter p xs
>     | otherwise = filter p xs

IO () 
Getting command line input from the user, and printing it to screen
-- :t getLine  :: IO String
-- :t putStrLn :: String -> IO ()
> main :: IO ()
> main = do
>     line <- getLine
>     putStrLn line

-- Identity Type
> data Identity a = Identity a

-- Maybe type, used for computations that may fail
> data Maybe a = Just a | Nothing

-- Example
> maybeExample :: IO ()
> maybeExample = do
>    line <- getLine
>    case readMaybe line :: Maybe Int of
>      Nothing  -> putStrLn "nothing"
>      Just num -> print num


